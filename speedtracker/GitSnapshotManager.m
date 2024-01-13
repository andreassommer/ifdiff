classdef GitSnapshotManager < SnapshotLoader
    % Snapshot manager that uses Git refs to store snapshots
    % Given an ID and commit, a snapshot is a ref to that commit. The ref's name contains the commit's
    % user date (in UTC) followed by the ID. This way, sorting snapshots by date committed - which is the obvious order
    % in which to run them - can be implemented by simply sorting lexicographically.


    properties (Constant)
        SNAPSHOT_ID_REGEX = "^[a-zA-Z][a-zA-Z0-9-_]*$";

        % Cannot save state, because the repo is in detached HEAD mode
        ERROR_DETACHED_HEAD = "GitSnapshotManager:detachedHead";
        ERROR_STAGED_CHANGES_PRESENT = "GitSnapshotManager:stagedChangesPresent";
        ERROR_BAD_COMMIT = "GitSnapshotManager:badCommit";
        ERROR_NAME_TAKEN = "GitSnapshotManager:nameTaken";

        ERROR_FS_GENERIC = "GitSnapshotManager:fileErrorGeneric";
        ERROR_GIT_GENERIC = "GitSnapshotManager:gitErrorGeneric";
        ERROR_ILLEGAL_STATE = "GitSnapshotManager:illegalState";
        ERROR_METADATA_ALREADY_PRESENT = "GitSnapshotManager:metadataAlreadyPresent";
        ERROR_NO_METADATA_PRESENT = "GitSnapshotManager:noMetadataPresent";
    end

    properties(Constant, Access=private)
        SNAPSHOT_TAG_PREFIX = "refs/speedtracker/snapshots";
        SNAPSHOT_TAG_REGEX = "^" + GitSnapshotManager.SNAPSHOT_TAG_PREFIX + ...
            "/" + "\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}--[a-zA-Z][a-zA-Z0-9-_]*$";
        SNAPSHOT_TAG_GLOB_PREFIX = GitSnapshotManager.SNAPSHOT_TAG_PREFIX + ...
            "/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-[0-9][0-9]-[0-9][0-9]-[0-9][0-9]-";
        SNAPSHOT_TAG_EXAMPLE_PREFIX = GitSnapshotManager.SNAPSHOT_TAG_PREFIX + "/YYYY-MM-DD-hh-mm-ss-";
        % Git ref name under which metadata about the saved state can be found. Due to the contract of
        % restoreProjectState, this must always be a class constant.
        METADATA_REF_NAME = "refs/speedtracker/snapshot-manager"
        METADATA_TEMP_FILE_NAME = "speedtracker-git-snapshot-manager-temp";
    end

    properties (Access=public)
        speedtrackerConfig;
        logger;
    end

    methods (Access=public)
        function instance = GitSnapshotManager(speedtrackerConfig, logger)
            instance.speedtrackerConfig = speedtrackerConfig;
            instance.logger = logger;
        end

        % Save the current state of the working directory. If there are any changes
        % in the index, throw an exception, because saving state without destroying the index is too difficult.
        % If there are changes in the working tree, commit them to a temporary commit and store information for
        % retrieving it in a tagged blob.
        %
        % Exceptions:
        %   If there are staged changes, throw SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE with a
        %        ERROR_STAGED_CHANGES_PRESENT as a cause
        %   The repo must be on a branch. If this is run in detached HEAD mode, throw 
        %       SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE with a ERROR_DETACHED_HEAD as a cause
        %   If there is already a saved state, throw SnapshotLoader.ERROR_SAVED_STATE_PRESENT
        % In all cases, leave the project behind the same state it was in before.
        function saveProjectState(this)
            % throws in case of E1, staged changes
            if ~this.isGitIndexClean()
                innerError = MException(GitSnapshotManager.ERROR_STAGED_CHANGES_PRESENT, ...
                    "cannot switch snapshots while there are staged changes");
                outerError = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, ...
                    "project's state cannot be saved");
                throw(outerError.addCause(innerError));
            end
            % throws in case of E2, detached head state
            currentBranch = this.getCurrentBranch();
            if strcmp(currentBranch, "")
                innerError = MException(GitSnapshotManager.ERROR_DETACHED_HEAD, ...
                    "cannot save state as repo is in detached HEAD mode");
                outerError = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, ...
                    "project's state cannot be saved");
                throw(outerError.addCause(innerError));
            end
            metadata = struct();
            metadata.branch = currentBranch;

            % If there were staged changes and a temp commit was created, store its SHA. Otherwise,
            % use the value -1 to indicate that no temp commit was created.
            worktreeClean = this.isGitStatusClean();
            if ~worktreeClean
                prevCommitSha = this.saveWorkdirToTempCommit();
                metadata.prevCommitSha = prevCommitSha;
            else
                metadata.prevCommitSha = "";
            end
            try
                this.pushMetadata(jsonencode(metadata));
            catch taggingError
                % here is where E3 is caught
                if (taggingError.identifier == GitSnapshotManager.ERROR_METADATA_ALREADY_PRESENT)
                    err = MException(SnapshotLoader.ERROR_SAVED_STATE_PRESENT, "cannot save project state, a save is already present");
                else
                    err = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, "coult not save project state");
                end
                err = err.addCause(taggingError);
                if ~worktreeClean
                    this.logger.error("undoing temp commit");
                    [status, cmdout] = SystemUtil.safeSystem(sprintf("git reset --mixed %s", prevCommitSha));
                    if status ~= 0
                        this.logger.error("failed to undo temporary commit: " + cmdout);
                    end
                end
                throw(err);
            end
        end

        % Load the snapshot specified by `id`. The previous state must already have been saved with
        % saveProjectState.
        %
        % Exceptions:
        %   If the ID is syntactically invalid or no such snapshot exists, throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
        %   If there is no saved state present, throw SnapshotLoader.ERROR_NO_SAVED_STATE
        function loadSnapshot(this, id)
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            tagName = this.getSnapshotTagName(id);
            if strcmp(tagName, "")
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, "no snapshot with ID " + id));
            end
            if ~this.isMetadataPresent()
                throw(MException(SnapshotLoader.ERROR_NO_SAVED_STATE, ...
                    "cannot load snapshot without first saving project state"));
            end
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git checkout %s", tagName));
            if status ~= 0
                throw(this.genericGitError(cmdout));
            end
        end

        % Restore the state of the project from the temporary snapshot created by saveProjectState and
        % delete the temp snapshot. Must guarantee:
        % 1. The snapshot can be restored statelessly, using only the same subclass - not instance - of
        %     SnapshotManager.
        % Exceptions:
        % SnapshotLoader.ERROR_NO_SAVED_STATE if there is no saved state to load
        % SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE if the saved state cannot be parsed or if the `git switch` or
        %    `git reset` commands required to restore fail.
        function restoreProjectState(this)
            if ~this.isMetadataPresent()
                throw(MException(SnapshotLoader.ERROR_NO_SAVED_STATE, ...
                    "could not restore project state because no saved state present"));
            end
            metadataString = this.popMetadata();
            try
                metadata = jsondecode(metadataString);
                branchName = metadata.branch;
                prevCommitSha = metadata.prevCommitSha;
            catch parseError
                outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, ...
                    "found save state, but could not parse it");
                throw(outerErr.addCause(parseError));
            end
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git switch %s", branchName));
            if (status ~= 0)
                % push back the metadata, so we end up in the same state as before calling the procedure
                this.pushMetadata(metadataString);
                this.logger.error("could not switch to saved branch, re-saving saved state");
                gitErr = this.genericGitError(cmdout);
                outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, "error switching to saved branch");
                throw(outerErr.addCause(gitErr));
            end
            if (strlength(prevCommitSha) > 0)
                [status, cmdout] = SystemUtil.safeSystem(sprintf("git reset --mixed %s", prevCommitSha));
                if (status ~= 0)
                    % would be nice to undo everything in this case too, but it looks to be impossible. 
                    % We can at least re-save the metadata so no information is lost.
                    this.pushMetadata(metadataString);
                    this.logger.error("could not reset to saved commit, re-saving save state");
                    gitErr = this.genericGitError(cmdout);
                    outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, "error resetting temp commit");
                    throw(outerErr.addCause(gitErr));
                end
            end
        end

        % Create a snapshot with a provided ID. If options.Commit is present, create the snapshot
        % from the commit it points to. Otherwise, use the commit pointed to by HEAD.
        % id: 1xN char or 1x1 string
        % options: struct with fields
        %   [CommitSha]
        %
        % The tag name is the provided ID prefixed with the commit's author date: For instance, a commit created
        % on 2023-12-05T18:30:22+01:00 and saved under the ID "mysnapshot" would be saved as a tag named
        % 2023-12-05-18-30-22-01-00-mysnapshot
        % Git for-each-ref only allows sorting by tag name or version, so 
        % To be able to search for these tags using only the name, we can use `git for-each-ref <...> <prefix>/*-mysnapshot"`.
        % Throw ERROR_BAD_SNAPSHOT_ID if the ID is not valid (syntactically), ERROR_BAD_COMMIT if the provided
        % SHA does not refer to a commit, and ERROR_NAME_TAKEN if the snapshot ID is already in use.
        function [id, commit] = createSnapshot(this, id, commitSha)
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            if nargin >= 3
                if ~this.isCommitSha(commitSha)
                    throw(MException(GitSnapshotManager.ERROR_BAD_COMMIT, "no commit with SHA " + commitSha));
                else
                    commit = commitSha;
                end
            else
                commit = this.getCurrentCommitSha();
            end
            existingTag = this.getSnapshotTagName(id);
            if strlength(existingTag) ~= 0
                throw(MException(GitSnapshotManager.ERROR_NAME_TAKEN, "snapshot with ID already exists: " + id));
            end
            preexistingSnapshots = this.getSnapshotsOfCommit(commit);
            if ~isempty(preexistingSnapshots)
                this.logger.warn(sprintf("commit is already tagged in the snapshots: %s", strjoin(preexistingSnapshots, ", ")));
            end
            ref = this.makeSnapshotTagName(id, commit);
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git update-ref %s %s", ref, commit));
            if status ~= 0
                throw(this.genericGitError(cmdout));
            end
        end

        % Delete a snapshot given its string ID as returned by createSnapshot.
        % Throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID if the ID is invalid or no such snapshot exists
        function [id, sha] = deleteSnapshot(this, id)
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            ref = this.getSnapshotTagName(id);
            if (strlength(ref) == 0)
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, "no such snapshot: " + id));
            end
            sha = this.getShaOfRef(ref);
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git update-ref -d %s", ref));
            if status ~= 0
                throw(this.genericGitError(cmdout));
            end
        end

        % list all snapshots matching a glob pattern and return a row vector of their IDs
        function snapshots = listSnapshots(this)
            tagNames = getAllSnapshotsTags(this);
            snapshots = arrayfun(@(tag) this.convertTagToSnapshotId(tag), tagNames');
        end

        % Get information about a snapshot, returning a dict with the properties:
        %   tagName: the snapshot's tag name
        %   commitSha: the snapshot's commit SHA
        %   author: the commit's author (Firstname Lastname <e@mail.address>)
        %   authorDate: author date (the one that governs which order snapshots are returned in) in Unix time (string)
        %   authorTimeZone: time zone of the author date, in the format +0100
        %   commitDate: commit date in Unix time (string)
        %   commitTimeZone: time zone of the commit date, in the format +0100
        %   subject: the "subject line", containing the commit message and some other stuff (and not necessarily one
        %   line long!
        function info = getSnapshotInfo(this, id)
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            tagName = this.getSnapshotTagName(id);
            if strcmp(tagName, "")
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, "no snapshot with ID " + id));
            end
            sha = this.getShaOfRef(tagName);

            % Get description
            commitDict = this.getCommitInfo(sha);
            commitDict("tagName") = tagName;
            commitDict("commitSha") = sha;
            info = commitDict;
        end

        % Check whether a snapshot exists. Since 
        function exists = snapshotExists(this, id)
            exists = this.isValidSnapshotID(id) && (strlength(this.getSnapshotTagName(id)) ~= 0);
        end
    end

    methods (Access=private)
        % Find out if metadata have been stored. Do this by simply checking for the tag that is mapped
        % to the metadata blob.
        function isPresent = isMetadataPresent(this)
            isPresent = this.getShaOfRef(GitSnapshotManager.METADATA_REF_NAME) ~= "";
        end

        % Store metadata in the Git object database (so it is safe against getting lost during checkout of snapshots)
        % Like a browser cookie, there is just one data string for GitSnapshotManager. For now, this is just
        % intended to be a really minimal "where was I?" so each method that uses it will just make its own JSON
        % and hopefully we won't need any more abstractions.
        function pushMetadata(this, stringData)
            if this.isMetadataPresent()
                throw(MException(GitSnapshotManager.ERROR_METADATA_ALREADY_PRESENT, "metadata already present"));
            end
            metadataTempFile = this.getMetadataTempFileName();
            this.logger.debug(sprintf("saving metadata via temp file %s", metadataTempFile));
            fileID = fopen(metadataTempFile, 'W');
            if (fileID == -1)
                throw(MException(GitSnapshotManager.ERROR_FS_GENERIC, "could not open file " + metadataTempFile));
            end
            try 
                fprintf(fileID, stringData);
            catch error
                fclose(fileID);
                rethrow(error);
            end
            fclose(fileID);
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git hash-object -w %s", metadataTempFile));
            if (status ~= 0)
                delete(metadataTempFile);
                throw(this.genericGitError(cmdout));
            end
            blobHash = cmdout;
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git update-ref %s %s", GitSnapshotManager.METADATA_REF_NAME, blobHash));
            if (status ~= 0)
                delete(metadataTempFile);
                throw(this.genericGitError(cmdout));
            end
            delete(metadataTempFile);
        end

        function filename = getMetadataTempFileName(this)
            filename = fullfile(this.speedtrackerConfig.tempDir, GitSnapshotManager.METADATA_TEMP_FILE_NAME);
        end

        % Get the metadata stored by pushMetadata. If there are metadata present, also delete them.
        % If there are none present, throw an exception with the identifier ERROR_NO_METADATA_PRESENT
        function stringData = popMetadata(this)
            if ~this.isMetadataPresent()
                throw(MException(GitSnapshotManager.ERROR_NO_METADATA_PRESENT, "no metadata present"));
            end
            blobHash = this.getShaOfRef(GitSnapshotManager.METADATA_REF_NAME);

            [status, cmdout] = SystemUtil.safeSystem(sprintf("git cat-file -p %s", blobHash));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            stringData = cmdout;

            % and finally delete the tag. The blob will be garbage collected eventually.
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git update-ref -d %s", GitSnapshotManager.METADATA_REF_NAME));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
        end

        % Save all current changes in the working directory to a temporary commit.
        % Must not be run if there are staged changes.
        % Returns the SHA of the previous commit, so we know what commit to `git reset --mixed` to when restoring.
        function prevCommitSha = saveWorkdirToTempCommit(this)
            % get last commit SHA
            [status, cmdout] = SystemUtil.safeSystem("git rev-parse HEAD");
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            prevCommitSha = cmdout;

            [status, cmdout] = SystemUtil.safeSystem("git add *");
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end

            % glob patterns ignore dot files in Bash, but this catches them. In CMD, it's a no-op.
            [status, cmdout] = SystemUtil.safeSystem("git add "".*""");
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end

            [status, commitCmdout] = SystemUtil.safeSystem(sprintf("git commit -m ""%s""", this.getTempCommitMessage()));
            if (status ~= 0)
                this.logger.error("could not commit current state, unstaging changes");
                [status, restoreCmdout] = SystemUtil.safeSystem("git restore --staged *");
                if status ~= 0
                    this.logger.error("error unstaging changes: " + restoreCmdout);
                end
                throw(this.genericGitError(commitCmdout));
            end
        end

        function message = getTempCommitMessage(~)
            message = "speedtracker current state temp commit";
        end

        %% Primitive or nearly-primitive Git functions
        % Get the name of the current branch. If the repo is in detached HEAD mode, return the empty string.
        function branch = getCurrentBranch(this)
            [status, cmdout] = SystemUtil.safeSystem("git rev-parse --abbrev-ref HEAD");
            if contains(cmdout, "HEAD")
                branch = "";
            elseif status ~= 0
                throw(this.genericGitError(cmdout));
            else
                branch = cmdout;
            end
        end

        % Return 1 if there are no staged changes, or 0 otherwise.
        function isClean = isGitIndexClean(~)
            [status, cmdout] = SystemUtil.safeSystem("git diff-index --cached HEAD");
            if (status == 0 && strlength(cmdout) == 0)
                isClean = 1;
            else
                isClean = 0;
            end
        end

        % Return 1 if the `git status` says that there are no changes present, neither in the index, the worktree,
        % nor any untracked files, 0 otherwise.
        function isClean = isGitStatusClean(this)
            [status, cmdout] = SystemUtil.safeSystem("git status");
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            messageGitStatusClean = "nothing to commit, working tree clean";
            if (contains(lower(cmdout), messageGitStatusClean))
                isClean = 1;
            else 
                isClean = 0;
            end
        end

        % Check if a string points to a commit (i.e. is a ref or SHA) 
        function exists = commitExists(~, str)
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git cat-file -t %s", str));
            exists = (status == 0) && (strcmp(cmdout, "commit"));
        end

        % Verify that a string is the SHA of a commit. Not a ref, but a commit.
        function isSha = isCommitSha(this, sha)
            if ~regexp(sha, "[a-f0-9]+")
                isSha = 0;
                return;
            end
            if ~this.commitExists(sha)
                isSha = 0;
                return;
            end
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git rev-parse --verify %s", sha));
            isSha = status == 0 && strcmp(sha, cmdout); % this check filters out refs, e.g. HEAD
        end

        % Get the SHA of the commit that HEAD is pointing to.
        function sha = getCurrentCommitSha(this)
            [status, cmdout] = SystemUtil.safeSystem("git rev-parse --verify HEAD");
            if (status == 1)
                throw(this.genericGitError(cmdout));
            end
            sha = cmdout;
        end

        % Get the SHA of the commit that a given ref is pointing to. If there is none, return the empty string.
        function commitSha = getShaOfRef(this, ref)
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git show-ref --hash %s", ref));
            if (status ~= 0 && strlength(cmdout) == 0)
                commitSha = "";
            elseif (status ~= 0)
                throw(this.genericGitError(cmdout));
            else
                commitSha = cmdout;
            end
        end

        % Return a generic exception for when a Git command went wrong in an unexpected way. This should never be used
        % for actual, expected error conditions. Only in cases where it should be impossible for anything to go wrong
        % (but you know how it is, we make mistakes, we don't know when exactly a Git command may return an error...),
        % include a check for error conditions and throw one of these so the error doesn't disappear silently.
        function err = genericGitError(~, cmdout)
            err = MException(GitSnapshotManager.ERROR_GIT_GENERIC, "error in Git command: " + cmdout);
        end

        %% Snapshot ID/tag ref wrangling
        % Given a 1xN char or a 1x1 string, determine if it is a valid snapshot name: it must start with
        % a letter and consist of only letters, digits, dashes, and underscores.
        function isValid = isValidSnapshotID(~, id)
            if regexp(id, GitSnapshotManager.SNAPSHOT_ID_REGEX)
                isValid = 1;
            else
                isValid = 0;
            end
        end

        function exception = invalidSnapshotIDException(~, id)
            idPattern = GitSnapshotManager.SNAPSHOT_ID_REGEX;
            exception = MException( ...
                SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, ...
                sprintf("input ""%s"" does not match the pattern for snapshot IDs: %s", id, idPattern) ...
            );
        end

        % Given a prospective snapshot ID and a commit SHA/ref it should point to, construct the ref for the tag that
        % will store it. To do this, the commit's author date is obtained in UTC:
        % 2023-12-05T18:30:22
        % then all non-numeric characters are replaced with dashes:
        % 2023-12-05-18-30-22
        % the ID is appended to this:
        % 2023-12-05-18-30-22-mysnapshot
        % and finally, the snapshot prefix:
        % refs/<prefix>/2023-12-05-18-30-22-mysnapshot
        % 
        % WARNING:
        % An ID will therefore not produce a unique tag name, so you must manually use getSnapshotTagName first to
        % check if an ID is already taken!
        % Does not check if the name is valid or if the commit exists.
        function ref = makeSnapshotTagName(this, id, commit)
            % get the author date of the commit:
            infoDict = this.getCommitInfo(commit);
            posixTime = infoDict("authorDate");
            date = datetime(str2double(posixTime), "ConvertFrom", "posixtime", "Format", "yyyy-MM-dd-HH-mm-ss");
            rawRef = strjoin([string(date), "-", id], "");
            ref = strjoin([GitSnapshotManager.SNAPSHOT_TAG_PREFIX, rawRef], "/");
        end

        % Given the ID of a snapshot, return the Git ref that points to the snapshot's commit. If it does not
        % exist, return the empty string. 
        function tagName = getSnapshotTagName(this, id)
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git for-each-ref --format=%%""(refname)"" %s%s", ...
                GitSnapshotManager.SNAPSHOT_TAG_GLOB_PREFIX, id));
            if (status == 1)
                throw(this.genericGitError(cmdout));
            end
            if contains(cmdout, SystemUtil.gitOutputLineSep())
                throw(MException(GitSnapshotManager.ERROR_ILLEGAL_STATE, sprintf("multiple tags for snapshot ID %s", id)));
            end
            tagName = cmdout;
        end

        % Get all snapshots' tag names
        function tags = getAllSnapshotsTags(this)
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git for-each-ref --format=%%""(refname)"" %s%s", ...
                GitSnapshotManager.SNAPSHOT_TAG_GLOB_PREFIX, "*"));
            if (status == 1)
                throw(this.genericGitError(cmdout));
            end
            tags = splitlines(cmdout);
            if strcmp(tags, "")
                tags = [];
            end
        end

        % extract the pure ID from a tag generated by makeSnapshotTagName. If the string passed in is not a valid
        % tag ref, return -1.
        function id = convertTagToSnapshotId(~, tagName)
            if ~regexp(tagName, GitSnapshotManager.SNAPSHOT_TAG_REGEX)
                id = -1;
                return;
            end
            prefixLength = strlength(GitSnapshotManager.SNAPSHOT_TAG_EXAMPLE_PREFIX);
            id = extractAfter(tagName, prefixLength);
        end

        % Get the IDs of all snapshots pointing at a commit in a column vector.
        function ids = getSnapshotsOfCommit(this, sha)
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git for-each-ref --format=%%""(refname)"" --points-at %s %s/*", ...
                sha, GitSnapshotManager.SNAPSHOT_TAG_PREFIX));
            if (status == 1)
                throw(this.genericGitError(cmdout));
            end
            if (strlength(cmdout) == 0)
                ids = [];
                return;
            end
            tags = splitlines(cmdout);
            ids = arrayfun(@(tag) this.convertTagToSnapshotId(tag), tags);
        end

        % Get info about a commit, returning a dictionary containing:
        %   author: the commit's author (Firstname Lastname <e@mail.address>)
        %   authorDate: author date (the one that governs which order snapshots are returned in) in Unix time (string)
        %   authorTimeZone: time zone of the author date, in the format +0100
        %   commitDate: commit date in Unix time (string)
        %   commitTimeZone: time zone of the commit date, in the format +0100
        %   subject: the "subject line", containing the commit message and some other stuff (and not necessarily one
        %   line long!
        function dict = getCommitInfo(this, sha)
            [status, cmdout] = SystemUtil.safeSystem(sprintf("git cat-file commit %s", sha));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            lines = splitlines(cmdout);
            % should have the structure `"author" <name> <email> <unixtime> <timezone>`
            authorLine = lines(startsWith(lines, "author"));
            authorWords = strsplit(authorLine{1});
            % should have the structure `"committer" <name> <email> <unixtime> <timezone>`
            committerLine = lines(startsWith(lines, "committer"));
            committerWords = strsplit(committerLine{1});
            author = strjoin(authorWords(2:end-2), " ");
            authorDate = authorWords{end-1};
            authorTimeZone = authorWords{end};
            commitDate = committerWords{end-1};
            commitTimeZone = committerWords{end};
            % the subject line is preceded by an empty line, that's how we identify it
            emptyLines = regexp(cmdout, strjoin([SystemUtil.gitOutputLineSep(), SystemUtil.gitOutputLineSep()], ""));
            subjectStart = emptyLines(1) + 1;
            subject = extractAfter(cmdout, subjectStart);
            dict = dictionary(["author", "authorDate", "authorTimeZone", "commitDate", "commitTimeZone", "subject"], ...
                [author, authorDate, authorTimeZone, commitDate, commitTimeZone, subject]);
        end
    end
end