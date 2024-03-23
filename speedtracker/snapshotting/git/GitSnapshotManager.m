classdef GitSnapshotManager < SnapshotLoader
    % Snapshot manager that stores snapshots based on Git commits
    % Functions:
    % 1. create, read, update, and delete snapshots (stored in a file that can be committed)
    %    Committing the snapshots file is a bit awkward, since these snapshots are supposed to describe commits.
    %    But since we already need the latest revision to use Speedtracker itself, it does not really cause any
    %    extra damage. The ideal solution would have been using Git refs or Git tagged blobs, but pushing and pulling
    %    these has been challenging. And replacing Git commands with simple file operations is simpler and more robust.
    % 2. Save project state and check out snapshots for performance regression testing (implementing the SnapshotLoader
    %    interface)
    % WARNING: do not mix these two functionalities. In a single run of Speedtracker, you may EITHER create, read,
    % update, and delete snapshots (as many as you like), OR load snapshots (as many as you like) - if you modify
    % the existing snapshots, the copy of the snapshot file in the temp dir will not be updated to reflect the
    % changes until a new run of Speedtracker.


    properties (Constant)
        SNAPSHOT_ID_REGEX = '^[a-zA-Z][a-zA-Z0-9-_]*$';

        % Cannot save state, because the repo is in detached HEAD mode
        ERROR_DETACHED_HEAD = 'GitSnapshotManager:detachedHead';
        ERROR_STAGED_CHANGES_PRESENT = 'GitSnapshotManager:stagedChangesPresent';
        ERROR_BAD_COMMIT = 'GitSnapshotManager:badCommit';
        ERROR_NAME_TAKEN = 'GitSnapshotManager:nameTaken';

        ERROR_FS_GENERIC = 'GitSnapshotManager:fileErrorGeneric';
        ERROR_GIT_GENERIC = 'GitSnapshotManager:gitErrorGeneric';
        ERROR_ILLEGAL_STATE = 'GitSnapshotManager:illegalState';
        ERROR_METADATA_ALREADY_PRESENT = 'GitSnapshotManager:metadataAlreadyPresent';
        ERROR_NO_METADATA_PRESENT = 'GitSnapshotManager:noMetadataPresent';
        ERROR_SNAPSHOTS_FILE_ACCESS = 'GitSnapshotManager:snapshotsFileAccess';
        ERROR_BAD_SNAPSHOTS_FILE = 'GitSnapshotManager:badSnapshotsFile';
    end

    properties(Constant, Access=private)
        % Git ref name under which metadata about the saved state can be found.
        % Due to the contract of restoreProjectState, this must always be a class constant.
        METADATA_REF_NAME = 'refs/speedtracker/snapshot-manager'
        METADATA_TEMP_FILE_NAME = 'speedtracker-git-snapshot-manager-temp';
        SNAPSHOTS_FILE_NAME = 'snapshots.txt';
        % Wait time between Snapshot check-outs
        % MATLAB doesn't grok that a file changed unless its timestamp on disk is a full second away from the timestamp
        % inside MATLAB. To ensure that the current snapshot is actually being used, we must wait 1s between checkouts.
        % Note that this also applies to restoreProjectState, but not to saveProjectState, since the latter does not
        % actually alter any files. So, here is our wait time in seconds.
        SNAPSHOT_LOAD_WAIT_TIME = 1;
    end

    properties (Access=public)
        logger;
    end

    properties (Access=private)
        lastSnapshotLoadTime;
    end

    methods (Access=public)
        function instance = GitSnapshotManager(logger)
            instance.logger = logger;
            instance.lastSnapshotLoadTime = instance.getPosixTime();
        end

        %% SnapshotLoader interface
        function this = saveProjectState(this)
            % Save the current state of the working directory.
            % The saved state is stored in the Git objects database, so it persists across check-outs.
            % If there are any changes
            % in the index, throw an exception, because saving state without destroying the index is too difficult.
            % If there are changes in the working tree, commit them to a temporary commit and store information for
            % retrieving it in a tagged blob.
            %
            % Exceptions:
            %   If there are staged changes, throw SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE with a
            %        ERROR_STAGED_CHANGES_PRESENT as a cause.
            %        Since we are saving changed files in the worktree using a temporary commit, it would be very
            %        difficult to reconstruct which changes were staged and which were not.
            %   The repo must be on a branch. If this is run in detached HEAD mode, throw 
            %       SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE with a ERROR_DETACHED_HEAD as a cause
            %   If there is already a saved state, throw SnapshotLoader.ERROR_SAVED_STATE_PRESENT
            % In all cases, leave the project behind the same state it was in before.

            % throws in case of E1, staged changes
            if ~this.isGitIndexClean()
                innerError = MException(GitSnapshotManager.ERROR_STAGED_CHANGES_PRESENT, ...
                    'cannot save state while there are staged changes');
                outerError = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, ...
                    'project''s state cannot be saved');
                throw(outerError.addCause(innerError));
            end

            % throws in case of E2, detached head state
            currentBranch = this.getCurrentBranch();
            if strcmp(currentBranch, '')
                innerError = MException(GitSnapshotManager.ERROR_DETACHED_HEAD, ...
                    'cannot save state as repo is in detached HEAD mode');
                outerError = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, ...
                    'project''s state cannot be saved');
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
                metadata.prevCommitSha = '';
            end
            try
                this.pushMetadata(jsonencode(metadata));
            catch taggingError
                % here is where E3 is caught
                if (taggingError.identifier == GitSnapshotManager.ERROR_METADATA_ALREADY_PRESENT)
                    err = MException(SnapshotLoader.ERROR_SAVED_STATE_PRESENT, ...
                        'cannot save project state, a save is already present');
                else
                    err = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, 'coult not save project state');
                end
                err = err.addCause(taggingError);
                if ~worktreeClean
                    this.logger.error('undoing temp commit');
                    [status, cmdout] = SystemUtil.safeSystem(sprintf('git reset --mixed %s', prevCommitSha));
                    if status ~= 0
                        this.logger.error(sprintf('failed to undo temporary commit: %s', cmdout));
                    end
                end
                throw(err);
            end
        end

        function this = loadSnapshot(this, id)
            % Load the snapshot specified by `id`. The previous state must already have been saved with saveProjectState.
            % Exceptions:
            %   If the ID is syntactically invalid or no such snapshot exists, throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
            %   If there is no saved state present, throw SnapshotLoader.ERROR_NO_SAVED_STATE
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            snapshots = this.loadSnapshots(this.getSnapshotsTempFileName());
            indices = snapshots.id == id;
            if isempty(indices(indices))
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, sprintf('no snapshot with ID %s', id)));
            end
            sha = snapshots.sha(indices);
            if ~this.isMetadataPresent()
                throw(MException(SnapshotLoader.ERROR_NO_SAVED_STATE, ...
                    'cannot load snapshot without first saving project state'));
            end
            % Ensure the wait time has already passed to avoid MATLAB using old versions of newly-checked out code
            waitTime = this.getWaitTimeForLoading();
            if (waitTime > 0)
                java.lang.Thread.sleep(waitTime);
            end
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git checkout %s', sha));
            if status ~= 0
                throw(this.genericGitError(cmdout));
            end
            this.lastSnapshotLoadTime = this.getPosixTime();
        end

        function this = restoreProjectState(this)
            % Restore the state of the project from the save state created by saveProjectState and delete the save state.
            % Must guarantee:
            % 1. The snapshot can be restored statelessly, using only the same subclass - not instance - of
            %     SnapshotManager.
            % Exceptions:
            % SnapshotLoader.ERROR_NO_SAVED_STATE if there is no saved state to load
            % SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE if the saved state cannot be parsed or if the `git switch` or
            %    `git reset` commands required to restore fail.
            if ~this.isMetadataPresent()
                throw(MException(SnapshotLoader.ERROR_NO_SAVED_STATE, ...
                    'could not restore project state because no saved state present'));
            end
            metadataString = this.popMetadata();
            try
                metadata = jsondecode(metadataString);
                branchName = metadata.branch;
                prevCommitSha = metadata.prevCommitSha;
            catch parseError
                this.logger.error('could not parse saved metadata, re-saving saved state');
                this.pushMetadata(metadataString);
                outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, ...
                    'found save state, but could not parse it');
                throw(outerErr.addCause(parseError));
            end
            % Ensure the wait time has already passed to avoid MATLAB using old versions of newly-checked out code
            waitTime = this.getWaitTimeForLoading();
            if (waitTime > 0)
                java.lang.Thread.sleep(waitTime);
            end

            [status, cmdout] = SystemUtil.safeSystem(sprintf('git switch %s', branchName));
            if (status ~= 0)
                % push back the metadata, so we end up in the same state as before calling the procedure
                this.pushMetadata(metadataString);
                this.logger.error('could not switch to saved branch, re-saving saved state');
                gitErr = this.genericGitError(cmdout);
                outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, 'error switching to saved branch');
                throw(outerErr.addCause(gitErr));
            end
            if (strlength(prevCommitSha) > 0)
                [status, cmdout] = SystemUtil.safeSystem(sprintf('git reset --mixed %s', prevCommitSha));
                if (status ~= 0)
                    % would be nice to undo everything in this case too, but it looks to be impossible. 
                    % We can at least re-save the metadata so no information is lost.
                    this.pushMetadata(metadataString);
                    this.logger.error('could not reset to saved commit, re-saving save state');
                    gitErr = this.genericGitError(cmdout);
                    outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, 'error resetting temp commit');
                    throw(outerErr.addCause(gitErr));
                end
            end
            this.lastSnapshotLoadTime = this.getPosixTime();
        end

        %% Snapshot editing (CRUD)
        function [id, commit] = createSnapshot(this, id, commitSha)
            % Create a snapshot with a provided ID.
            % If the third parameter commitSha is passed, create the snapshot from the commit it points to.
            % Otherwise, use the commit pointed to by HEAD.
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            if nargin >= 3
                if ~this.isCommitSha(commitSha)
                    throw(MException(GitSnapshotManager.ERROR_BAD_COMMIT, sprintf( ...
                            'no commit with SHA %s', commitSha)));
                else
                    commit = commitSha;
                end
            else
                commit = this.getCurrentCommitSha();
            end
            snapshots = this.loadSnapshots(this.getSnapshotsFileName());
            snapshotsWithSameId = snapshots.id(snapshots.id == id);
            if ~isempty(snapshotsWithSameId)
                throw(MException(GitSnapshotManager.ERROR_NAME_TAKEN, sprintf( ...
                    'snapshot with ID already exists: %s', id)));
            end
            snapshotsWithSameSha = snapshots.id(snapshots.sha == commit);
            if ~isempty(snapshotsWithSameSha)
                this.logger.warn(sprintf('commit is already tagged in the snapshots: %s', strjoin(snapshotsWithSameSha, ', ')));
            end
            infoDict = this.getCommitInfo(commit);
            timestamp = str2double(infoDict('authorDate'));
            newSnapshots = this.appendSnapshots(snapshots, this.makeSnapshotList(id, commit, timestamp));
            this.saveSnapshots(newSnapshots, this.getSnapshotsFileName());
        end

        function [id, sha] = deleteSnapshot(this, id)
            % Delete a snapshot.
            % Throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID if the ID is invalid or no such snapshot exists
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            snapshots = this.loadSnapshots(this.getSnapshotsFileName());
            indices = snapshots.id == id;
            if isempty(indices(indices))
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, sprintf('no such snapshot: %s', id)));
            end
            snapshotToGo = this.idxSnapshots(snapshots, indices);
            sha = snapshotToGo.sha;
            remainingSnapshots = this.idxSnapshots(snapshots, ~indices);
            this.saveSnapshots(remainingSnapshots, this.getSnapshotsFileName());
        end

        function snapshots = listSnapshots(this)
            % return all snapshots' IDs sorted ascendingly by their commit's author date, i.e. when the commit was created.
            snapshotList = this.loadSnapshots(this.getSnapshotsFileName());
            [~, indices] = sort(snapshotList.timestamp);
            snapshots = num2cell(snapshotList.id(indices));
            snapshots = cellfun(@char, snapshots, 'UniformOutput', false);
        end

        function info = getSnapshotInfo(this, id)
            % Get information about a snapshot, returning a dictionary
            % The dictionary contains the properties:
            %   commitSha: the snapshot's commit SHA
            %   author: the commit's author (Name <e@mail.address>)
            %   authorDate: author date (the one that governs which order snapshots are returned in) in Unix time (string)
            %   authorTimeZone: time zone of the author date, in the format +0100
            %   commitDate: commit date in Unix time (string)
            %   commitTimeZone: time zone of the commit date, in the format +0100
            %   subject: the 'subject line', containing the commit message and some other stuff (and not necessarily one
            %   line long!
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            snapshots = this.loadSnapshots(this.getSnapshotsFileName());
            indices = snapshots.id == id;
            if isempty(indices(indices))
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, sprintf('no snapshot with ID %s', id)));
            end
            sha = snapshots.sha(indices);

            % Get description
            commitDict = this.getCommitInfo(sha);
            commitDict('commitSha') = sha;
            info = commitDict;
        end
    end

    methods (Access=private)
        %% Metadata Storage for Project State Saving
        function isPresent = isMetadataPresent(this)
            % Find out if metadata have been stored.
            % Do this by simply checking for the git ref that points to the metadata blob.
            isPresent = ~strcmp(this.getShaOfRef(GitSnapshotManager.METADATA_REF_NAME), '');
        end

        function pushMetadata(this, stringData)
            % Store metadata in the Git object database (so it is safe against getting lost during checkout of snapshots)
            % Like a browser cookie, there is just one data string for GitSnapshotManager. For now, this is just
            % intended to be a really minimal 'where was I?' so each method that uses it will just make its own JSON
            % and hopefully we won't need any more abstractions.
            if this.isMetadataPresent()
                throw(MException(GitSnapshotManager.ERROR_METADATA_ALREADY_PRESENT, 'metadata already present'));
            end
            metadataTempFile = this.getMetadataTempFileName();
            this.logger.debug(sprintf('saving metadata via temp file %s', metadataTempFile));
            fileID = fopen(metadataTempFile, 'W');
            if (fileID == -1)
                throw(MException(GitSnapshotManager.ERROR_FS_GENERIC, ...
                    sprintf('could not open file %s', metadataTempFile)));
            end
            try 
                fprintf(fileID, stringData);
            catch error
                fclose(fileID);
                rethrow(error);
            end
            fclose(fileID);
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git hash-object -w %s', metadataTempFile));
            if (status ~= 0)
                delete(metadataTempFile);
                throw(this.genericGitError(cmdout));
            end
            blobHash = cmdout;
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git update-ref %s %s', GitSnapshotManager.METADATA_REF_NAME, blobHash));
            if (status ~= 0)
                delete(metadataTempFile);
                throw(this.genericGitError(cmdout));
            end
            delete(metadataTempFile);
        end

        function filename = getMetadataTempFileName(~)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            filename = fullfile(speedtrackerConfig.tempDir, GitSnapshotManager.METADATA_TEMP_FILE_NAME);
        end

        function stringData = popMetadata(this)
        % Pop the metadata stored by pushMetadata.
        % If there are metadata present, delete them. If there are none present, throw an exception
        % with the identifier ERROR_NO_METADATA_PRESENT
            if ~this.isMetadataPresent()
                throw(MException(GitSnapshotManager.ERROR_NO_METADATA_PRESENT, 'no metadata present'));
            end
            blobHash = this.getShaOfRef(GitSnapshotManager.METADATA_REF_NAME);

            [status, cmdout] = SystemUtil.safeSystem(sprintf('git cat-file -p %s', blobHash));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            stringData = cmdout;

            % and finally delete the tag. The blob will be garbage collected eventually.
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git update-ref -d %s', GitSnapshotManager.METADATA_REF_NAME));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
        end

        function prevCommitSha = saveWorkdirToTempCommit(this)
            % Save all current changes in the working directory to a temporary commit.
            % Must not be run if there are staged changes.
            % Returns the SHA of the previous commit, so we know what commit to `git reset --mixed` to when restoring.

            % get last commit SHA
            [status, cmdout] = SystemUtil.safeSystem('git rev-parse HEAD');
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            prevCommitSha = cmdout;

            [status, cmdout] = SystemUtil.safeSystem('git add .');
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end

            [status, commitCmdout] = SystemUtil.safeSystem(sprintf('git commit -m "%s"', this.getTempCommitMessage()));
            if (status ~= 0)
                this.logger.error('could not commit current state, unstaging changes');
                [status, restoreCmdout] = SystemUtil.safeSystem('git restore --staged *');
                if status ~= 0
                    this.logger.error(sprintf('error unstaging changes: %s', restoreCmdout));
                end
                throw(this.genericGitError(commitCmdout));
            end
        end

        function message = getTempCommitMessage(~)
            message = 'speedtracker current state temp commit';
        end

        %% Snapshot ID wrangling
        function isValid = isValidSnapshotID(~, id)
            % Given a 1xN char or a 1x1 string, determine if it is a valid snapshot name
            % It must start with
            % a letter and consist of only letters, digits, dashes, and underscores.
            if regexp(id, GitSnapshotManager.SNAPSHOT_ID_REGEX)
                isValid = 1;
            else
                isValid = 0;
            end
        end

        function exception = invalidSnapshotIDException(~, id)
            % Create an exception for bad snapshot IDs
            idPattern = GitSnapshotManager.SNAPSHOT_ID_REGEX;
            exception = MException( ...
                SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, ...
                sprintf('input ''%s'' does not match the pattern for snapshot IDs: %s', id, idPattern) ...
            );
        end

        %% Primitive or nearly-primitive Git functions
        function commitSha = getShaOfRef(this, ref)
            % Get the SHA of the object that a given ref is pointing to. If there is none, return the empty string.
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git show-ref --hash %s', ref));
            if (status ~= 0 && strlength(cmdout) == 0)
                commitSha = '';
            elseif (status ~= 0)
                throw(this.genericGitError(cmdout));
            else
                commitSha = cmdout;
            end
        end

        function branch = getCurrentBranch(this)
            % Get the name of the current branch. If the repo is in detached HEAD mode, return the empty string.
            [status, cmdout] = SystemUtil.safeSystem('git rev-parse --abbrev-ref HEAD');
            if contains(cmdout, 'HEAD')
                branch = '';
            elseif status ~= 0
                throw(this.genericGitError(cmdout));
            else
                branch = cmdout;
            end
        end

        function isClean = isGitIndexClean(~)
            % Return 1 if there are no staged changes, or 0 otherwise.
            [status, cmdout] = SystemUtil.safeSystem('git diff-index --cached HEAD');
            if (status == 0 && strlength(cmdout) == 0)
                isClean = 1;
            else
                isClean = 0;
            end
        end

        function isClean = isGitStatusClean(this)
            % Return 1 if the `git status` says that there are no changes present, 0 otherwise
            % Returns 1 only if there are no changes in the index, the worktree, nor any untracked files.
            [status, cmdout] = SystemUtil.safeSystem('git status');
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            messageGitStatusClean = 'nothing to commit, working tree clean';
            if (contains(lower(cmdout), messageGitStatusClean))
                isClean = 1;
            else 
                isClean = 0;
            end
        end

        function exists = commitExists(~, str)
            % Check if a string points to a commit (i.e. is a ref or SHA) 
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git cat-file -t %s', str));
            exists = (status == 0) && (strcmp(cmdout, 'commit'));
        end

        function isSha = isCommitSha(this, sha)
            % Verify that a string is the SHA of a commit. Not a ref, but a commit.
            if ~regexp(sha, '[a-f0-9]+')
                isSha = 0;
                return;
            end
            if ~this.commitExists(sha)
                isSha = 0;
                return;
            end
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git rev-parse --verify %s', sha));
            isSha = status == 0 && strcmp(sha, cmdout); % this check filters out refs, e.g. HEAD
        end

        function sha = getCurrentCommitSha(this)
            % Get the SHA of the commit that HEAD is pointing to.
            [status, cmdout] = SystemUtil.safeSystem('git rev-parse --verify HEAD');
            if (status == 1)
                throw(this.genericGitError(cmdout));
            end
            sha = cmdout;
        end

        function err = genericGitError(~, cmdout)
            % Return a generic exception for when a Git command went wrong in an unexpected way.
            % This should never be used for actual, expected error conditions. Only in cases where it
            % should be impossible for anything to go wrong (but you know how it is - we make mistakes,
            % we don't know when exactly a Git command may return an error...),
            % include a check for error conditions and throw one of these so the error doesn't disappear silently.
            err = MException(GitSnapshotManager.ERROR_GIT_GENERIC, sprintf('error in Git command: %s', cmdout));
        end

        function dict = getCommitInfo(this, sha)
            % Get info about a commit, returning a dictionary
            % Properties:
            %   author: the commit's author (Firstname Lastname <e@mail.address>)
            %   authorDate: author date (the one that governs which order snapshots are returned in) in Unix time (string)
            %   authorTimeZone: time zone of the author date, in the format +0100
            %   commitDate: commit date in Unix time (string)
            %   commitTimeZone: time zone of the commit date, in the format +0100
            %   subject: the 'subject line', containing the commit message and some other stuff (and not necessarily one
            %   line long!
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git cat-file commit %s', sha));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            lines = splitlines(cmdout);
            % should have the structure `'author' <name> <email> <unixtime> <timezone>`
            authorLine = lines(startsWith(lines, 'author'));
            authorWords = strsplit(authorLine{1});
            % should have the structure `'committer' <name> <email> <unixtime> <timezone>`
            committerLine = lines(startsWith(lines, 'committer'));
            committerWords = strsplit(committerLine{1});
            author = strjoin(authorWords(2:end-2), ' ');
            authorDate = authorWords{end-1};
            authorTimeZone = authorWords{end};
            commitDate = committerWords{end-1};
            commitTimeZone = committerWords{end};
            % the subject line is preceded by an empty line, that's how we identify it
            emptyLines = regexp(cmdout, strjoin({SystemUtil.gitOutputLineSep(), SystemUtil.gitOutputLineSep()}, ''));
            subjectStart = emptyLines(1) + 1;
            subject = extractAfter(cmdout, subjectStart);
            dict = dictionary(["author", "authorDate", "authorTimeZone", "commitDate", "commitTimeZone", "subject"], ...
                [author, authorDate, authorTimeZone, commitDate, commitTimeZone, subject]);
        end

        %% Snapshot Storage
        % Each snapshot is a struct consisting of ID (name given by user), commit SHA, and timestamp, with the keys
        % `id`, `sha`, and `timestamp`, respectively. The latter
        % property is to facilitate sorting them by date, allowing them to be tested in the order their commits were
        % created, which is the obvious order when we want to see whether IFDIFF's performance has degraded over
        % time. A set of snapshots is passed around not as an array of structs, but as a struct of arrays
        % (row vectors), called a _snapshot list_.
        % For storage, we simply write each snapshot on a line with id, sha, and timestamp separated by spaces.

        function filename = getSnapshotsFileName(~)
            % Get the filename for the snapshot file.
            % Note: this is the file in the original
            % speedtracker directory, not the temp dir! Do not mix snapshot CRUD and snapshot loading.
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig(); 
            filename = fullfile(speedtrackerConfig.speedtrackerDir, GitSnapshotManager.SNAPSHOTS_FILE_NAME);
        end

        function filename = getSnapshotsTempFileName(~)
            % Get the filename for the temp copy of the snapshot file.
            % Needed when loading snapshots, because the original will be overwritten by loading snapshots.
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig(); 
            filename = fullfile(speedtrackerConfig.tempDir, GitSnapshotManager.SNAPSHOTS_FILE_NAME);
        end

        function snapshots = loadSnapshots(this, file)
            % Read a snapshot file and return a snapshot list. If it does not exist, return an empty snapshot list.
            % throw GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS if the file cannot be opened/written
            %   and GitSnapshotManager.ERROR_BAD_SNAPSHOTS_FILE if the file cannot be parsed.
            if ~isfile(file)
                snapshots = this.makeSnapshotList(strings(0), strings(0), zeros(0));
                return;
            end
            try
                text = fileread(file, 'Encoding', 'UTF-8');
            catch fileError
                error = MException(GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS, ...
                    sprintf('error opening or reading snapshot file: %s', fileError.message));
                throw(error.addCause(fileError));
            end
            lines = splitlines(string(text));
            lines = lines(~startsWith(lines, '#'));
            lines = lines(strlength(lines) > 0);
            snapshotArray = strings(length(lines), 3);
            for i=1:length(lines)
                words = strsplit(lines(i));
                if length(words) ~= 3
                    throw(MException(GitSnapshotManager.ERROR_BAD_SNAPSHOTS_FILE, ...
                        sprintf('snapshot #%d in %s is malformed %s', i, file, lines(i))));
                end
                snapshotArray(i, :) = words;
            end
            timestamps = cellfun(@str2double, snapshotArray(:, 3));
            snapshots = this.makeSnapshotList(snapshotArray(:, 1)', snapshotArray(:, 2)', timestamps');
        end

        function saveSnapshots(~, snapshots, file)
            % Save snapshots given as a snapshot list to a snapshot file. If there are 0 snapshots, delete the file.
            % throw GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS if the snapshot file cannot be accessed
            if (isempty(snapshots.id))
                try
                    delete(file);
                    return;
                catch fileError
                    error = MException(GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS, ...
                        sprintf('error accessing snapshot file: %s', fileError.message));
                    throw(error.addCause(fileError));
                end
            end
            snapshotArray = strings(length(snapshots.id), 3);
            snapshotArray(:, 1) = snapshots.id';
            snapshotArray(:, 2) = snapshots.sha';
            snapshotArray(:, 3) = string(snapshots.timestamp)';
            lines = strings(1, size(snapshotArray, 1));
            for i=1:size(snapshotArray, 1)
                lines(i) = strjoin(snapshotArray(i, :), ' ');
            end
            output = strjoin(lines, SystemUtil.lineSep());
            try
                writelines(output, file, 'Encoding', 'UTF-8');
            catch fileError
                error = MException(GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS, ...
                    sprintf('error opening or writing snapshot file: %s', fileError.message));
                throw(error.addCause(fileError));
            end
        end

        function list = makeSnapshotList(~, id, sha, timestamp)
            list = struct('id', id, 'sha', sha, 'timestamp', timestamp);
        end

        function subList = idxSnapshots(~, snapshotList, idx)
            % Given a snapshot list, get the sublist (or individual snapshot) at the provided indices
            if length(size(idx)) > 2 || size(idx, 1) > 1 && size(idx, 2) > 1
                throw(MException('GitSnapshotManager:index', 'index array must be a scalar or vector'));
            end
            subList = struct('id', snapshotList.id(idx), 'sha', snapshotList.sha(idx), 'timestamp', snapshotList.timestamp(idx));
        end

        function s12 = appendSnapshots(this, s1, s2)
            s12 = this.makeSnapshotList([s1.id s2.id], [s1.sha s2.sha], [s1.timestamp s2.timestamp]);
        end

        %% Miscellaneous
        function milliseconds = getWaitTimeForLoading(this)
            % How long we must wait before the next snapshot loading operation, in milliseconds
            secondsSinceLastLoad = (this.getPosixTime() - this.lastSnapshotLoadTime);
            milliseconds = (GitSnapshotManager.SNAPSHOT_LOAD_WAIT_TIME - secondsSinceLastLoad) * 1000;
        end
        function seconds = getPosixTime(~)
            seconds = posixtime(datetime('now', 'TimeZone', '+0000'));
        end
    end
end