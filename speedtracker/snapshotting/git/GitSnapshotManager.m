classdef GitSnapshotManager < SnapshotLoader
    % Snapshot manager that stores snapshots based on Git commits
    % Functions:
    % 1. create, read, update, and delete snapshots (stored in a file that can be committed)
    %    Committing the snapshots file is a bit weird, since these snapshots are supposed to describe commits. So
    %    then the file storing commits is stored in a commit... who manipulates who here?
    %    However, you can't really run speedtracker while you have an old commit checked out. So we might as well
    %    make the snapshots file be tied to the latest commit.
    %    The ideal solution would have been using Git refs or Git tagged blobs, but pushing and pulling
    %    these has been challenging. The snapshots file also has the advantage that manipulating it just consists
    %    of reading/writing a file rather than using obscure Git plumbing commands.
    % 2. Save project state and check out snapshots for performance regression testing (implementing the SnapshotLoader
    %    interface). Instead of checking out created snapshots, you can also directly pass a commit SHA to check it out.
    %    If there are working tree changes, GSM will save these to a temp commit and restore them once it's done, no
    %    problem. However, if there are staged changes, it will not work.
    % WARNING: do not mix these two functionalities. In a single run of Speedtracker, you may EITHER create, read,
    % update, and delete snapshots (as many as you like), OR load snapshots (as many as you like) - if you modify
    % the existing snapshots, the copy of the snapshot file in the temp dir will not be updated to reflect the
    % changes until a new run of Speedtracker.


    properties (Constant)
        % Snapshot ID regex: starts with a letter, contains only letters, digits, dashes, and underscores
        SNAPSHOT_ID_REGEX = '^[a-zA-Z][a-zA-Z0-9-_]*$';

        %% Expected Exception Identifiers

        % Cannot save state, because the repo is in detached HEAD mode
        ERROR_DETACHED_HEAD = 'GitSnapshotManager:detachedHead';
        % Cannot save state, because there are staged changes present
        ERROR_STAGED_CHANGES_PRESENT = 'GitSnapshotManager:stagedChangesPresent';
        % Tried to create a snapshot from a nonexistent or otherwise invalid commit
        ERROR_BAD_COMMIT = 'GitSnapshotManager:badCommit';
        % Snapshot name is alreayd taken
        ERROR_NAME_TAKEN = 'GitSnapshotManager:nameTaken';

        %% Unexpected Exception Identifiers

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
        % Note that this also applies to restoreProjectState, but not to saveProjectState, since the latter only
        % creates a new commit and does not actually alter any files. So, here is our wait time, in seconds.
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
            % The saved state is stored in a tagged blob in the Git objects database, so it persists across check-outs.
            % If there are any changes
            % in the index, throw an exception, because saving state without destroying the index is too difficult.
            % If there are changes in the working tree, commit them to a temporary commit and store information for
            % retrieving it in the objects DB.
            %
            % Exceptions:
            %   E1 If there are staged changes, throw SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE with a
            %        ERROR_STAGED_CHANGES_PRESENT as a cause.
            %        Since we are saving changed files in the worktree using a temporary commit, it would be very
            %        difficult to reconstruct which changes were staged and which were not.
            %   E2 The repo must be on a branch. If this method is called while the repo is in detached HEAD mode, throw
            %       SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE with a ERROR_DETACHED_HEAD as a cause.
            %   E3 If there is already a saved state, throw SnapshotLoader.ERROR_SAVED_STATE_PRESENT
            % In all cases, leave the repo behind the same state it was in before.

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
                [headCommitSha, tempCommitSha] = this.saveWorkdirToTempCommit();
                metadata.headCommitSha = headCommitSha;
                metadata.tempCommitSha = tempCommitSha;
            else
                metadata.headCommitSha = this.getCurrentCommitSha();
            end
            try
                this.writeMetadata(jsonencode(metadata));
            catch taggingError
                % here is where E3 is handled
                if (taggingError.identifier == GitSnapshotManager.ERROR_METADATA_ALREADY_PRESENT)
                    err = MException(SnapshotLoader.ERROR_SAVED_STATE_PRESENT, ...
                        'cannot save project state, a save is already present');
                else
                    err = MException(SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE, 'coult not save project state');
                end
                err = err.addCause(taggingError);
                if ~worktreeClean
                    this.logger.error('undoing temp commit');
                    [status, cmdout] = SystemUtil.safeSystem(sprintf('git reset --mixed %s', headCommitSha));
                    if status ~= 0
                        this.logger.error(sprintf('failed to undo temporary commit: %s', cmdout));
                    end
                end
                throw(err);
            end
        end

        function this = loadSnapshot(this, snapshotSpecifier)
            % Load a saved snapshot, commit, or the special snapshots 'worktree'/'current'
            % Commits can also be referenced with refs, HEAD, HEAD~, HEAD^, and any other way that Git accepts.
            % The special names "worktree" and "current" refer to the state of the worktree, including uncommitted
            % changes, when speedtracker is invoked.
            % This method can only be called if saveProjectState was called first to save the current repo state.
            % Exceptions:
            %   If snapshotSpecifier does not refer to a snapshot in any of the three mentioned ways, throw
            %     SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
            %   If there is no saved state present, throw SnapshotLoader.ERROR_NO_SAVED_STATE
            % See also SAVEPROJECTSTATE, RESTOREPROJECTSTATE, CREATESNAPSHOT

            if ~this.isMetadataPresent()
                throw(MException(SnapshotLoader.ERROR_NO_SAVED_STATE, ...
                    'cannot load snapshot without first saving project state'));
            end

            sha = this.resolveSnapshotSha(snapshotSpecifier);
            if strlength(sha) == 0
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, sprintf( ...
                    '%s is not a snapshot ID, revision specifier, or special snapshot name', snapshotSpecifier)));
            end
            this.logger.info(sprintf('  snapshot SHA: %s', sha));
            % Ensure the wait time has already passed to avoid MATLAB using old versions of newly-checked out code
            waitTime = this.getWaitTimeForLoading();
            if (waitTime > 0)
                pause(waitTime);
            end
            this.checkoutCommit(sha);
            rehash;
            this.lastSnapshotLoadTime = this.getPosixTime();
        end

        function this = restoreProjectState(this)
            % Restore the state of the project from the save state created by saveProjectState and delete
            % the metadata of the save state.
            % You do not need to use the same instance of GitSnapshotManager to restore state; all required information
            % is stored in the Git database, as per R1 of the SnapshotLoader interface
            % Exceptions:
            % SnapshotLoader.ERROR_NO_SAVED_STATE if there is no saved state to load
            % SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE if the saved state cannot be parsed or if the `git switch` or
            %    `git reset` commands required to restore fail for whatever reason.
            % See also SAVEPROJECTSTATE, SNAPSHOTLOADER
            if ~this.isMetadataPresent()
                throw(MException(SnapshotLoader.ERROR_NO_SAVED_STATE, ...
                    'could not restore project state because no saved state present'));
            end
            metadataString = this.readMetadata();
            this.deleteMetadata();
            try
                metadata = jsondecode(metadataString);
                branchName = metadata.branch;
                headCommitSha = metadata.headCommitSha;
                if isfield(metadata, 'tempCommitSha')
                    tempCommitSha = metadata.tempCommitSha;
                else
                    tempCommitSha = '';
                end
            catch parseError
                this.logger.error('could not parse saved metadata, re-saving saved state');
                this.writeMetadata(metadataString);
                outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, ...
                    'found save state, but could not parse it');
                throw(outerErr.addCause(parseError));
            end
            % Ensure the wait time has already passed to avoid MATLAB using old versions of newly-checked out code
            waitTime = this.getWaitTimeForLoading();
            if (waitTime > 0)
                pause(waitTime);
            end

            [status, cmdout] = SystemUtil.safeSystem(sprintf('git switch %s', branchName));
            rehash;
            if (status ~= 0)
                % push back the metadata, so we end up in the same state as before calling the procedure
                this.writeMetadata(metadataString);
                this.logger.error('could not switch to saved branch, re-saving saved state');
                gitErr = this.genericGitError(cmdout);
                outerErr = MException(SnapshotLoader.ERROR_COULD_NOT_LOAD_STATE, 'error switching to saved branch');
                throw(outerErr.addCause(gitErr));
            end
            if (strlength(tempCommitSha) > 0)
                [status, cmdout] = SystemUtil.safeSystem(sprintf('git reset --mixed %s', headCommitSha));
                if (status ~= 0)
                    % would be nice to undo everything in this case too, but it looks to be impossible. 
                    % We can at least re-save the metadata so no information is lost.
                    this.writeMetadata(metadataString);
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
            % Throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID if the ID does not match GitSnapshotManager.SNAPSHOT_ID_REGEX
            % or is already taken. Throw GitSnapshotManager.ERROR_BAD_COMMIT if the commit does not exist.
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end
            if this.isSpecialSnapshotName(id)
                this.logger.warn('a snapshot named %s cannot be used, as %s is a reserved special snapshot name');
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
            snapshotsWithSameId = snapshots(arrayfun(@(snapshot) strcmp(snapshot.id, id), snapshots));
            if ~isempty(snapshotsWithSameId)
                throw(MException(GitSnapshotManager.ERROR_NAME_TAKEN, sprintf( ...
                    'snapshot with ID already exists: %s', id)));
            end
            snapshotsWithSameSha = snapshots(arrayfun(@(snapshot) strcmp(snapshot.sha, commit), snapshots));
            sameShaIDs = arrayfun(@(snapshot) snapshot.id, snapshotsWithSameSha, 'UniformOutput', false);
            if ~isempty(sameShaIDs)
                this.logger.warn(sprintf('commit is already tagged in the snapshots: %s', strjoin(sameShaIDs, ', ')));
            end
            commitInfo = this.getCommitInfo(commit);
            timestamp = str2double(olGetOption(commitInfo, 'AuthorDate'));
            newSnapshots = [snapshots this.makeSnapshotStruct(id, commit, timestamp)];
            this.saveSnapshots(newSnapshots, this.getSnapshotsFileName());
        end

        function [id, sha] = deleteSnapshot(this, id)
            % Delete a snapshot.
            % Throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID if the ID is invalid or no such snapshot exists
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end

            snapshots = this.loadSnapshots(this.getSnapshotsFileName());
            snapshotToGo = this.getSnapshotById(snapshots, id);
            if isempty(snapshotToGo)
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, sprintf('no such snapshot: %s', id)));
            end
            sha = snapshotToGo.sha;

            remainingSnapshots = snapshots(arrayfun(@(snapshot) ~strcmp(snapshot.id, id), snapshots));
            this.saveSnapshots(remainingSnapshots, this.getSnapshotsFileName());
        end

        function snapshotIDs = listSnapshots(this)
            % return all snapshots' IDs sorted ascendingly by their commit's author date
            % i.e. when the commit was created.
            snapshots = this.loadSnapshots(this.getSnapshotsFileName());
            [~, indices] = sort(arrayfun(@(snapshot) snapshot.timestamp, snapshots));
            snapshots = snapshots(indices);
            snapshotIDs = arrayfun(@(snapshot) snapshot.id, snapshots, 'UniformOutput', false);
        end

        function info = getSnapshotInfo(this, id)
            % Get information about a snapshot, returning an optionlist (see utils/optionlist/olIsOptionlist.m)
            % The list contains the properties:
            %   CommitSha: the snapshot's commit SHA
            %   Author: the commit's author (Name <e@mail.address>)
            %   AuthorDate: author date (the one that governs which order snapshots are returned in) in Unix
            %     time (string)
            %   AuthorTimeZone: time zone of the author date, in the format +0100
            %   CommitDate: commit date in Unix time (string)
            %   CommitTimeZone: time zone of the commit date, in the format +0100
            %   Subject: the 'subject line', containing the commit message and some other stuff (and not necessarily
            %     only one line long!)
            % Throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID if the snapshot ID does not match
            % GitSnapshotManager.SNAPSHOT_ID_REGEX or if the snapshot does not exist.
            % This also does not work for raw commit SHAs, unlike loadSnapshot. You can just use `git show` for those,
            % because this method doesn't do anything more than that either.
            if ~this.isValidSnapshotID(id)
                throw(this.invalidSnapshotIDException(id));
            end

            snapshots = this.loadSnapshots(this.getSnapshotsFileName());
            snapshot = this.getSnapshotById(snapshots, id);
            if isempty(snapshot)
                throw(MException(SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, sprintf('no such snapshot: %s', id)));
            end
            sha = snapshot.sha;

            % Get description
            info = this.getCommitInfo(sha);
            info = olSetOption(info, 'CommitSha', sha);
        end

        function exists = snapshotExists(this, snapshotSpecifier)
            % Return true if a the provided character string can be interpreted as a snapshot
            % i.e. if it is the ID of a snapshot, if it is 'current' or 'worktree', or if it is a valid git
            % revision specifier (tested with `git rev-parse`)
            if this.isMetadataPresent()
                exists = ~strcmp(this.resolveSnapshotSha(snapshotSpecifier), '');
                return;
            end
            if this.isSpecialSnapshotName(snapshotSpecifier)
                exists = true;
                return;
            end
            if this.isValidSnapshotID(snapshotSpecifier)
                snapshots = this.loadSnapshots(this.getSnapshotsFileName());
                snapshot = this.getSnapshotById(snapshots, snapshotSpecifier);
                if ~isempty(snapshot)
                    exists = true;
                    return;
                end
            end
            % attempt to dereference the revision specifier with Git
            [status, ~] = SystemUtil.safeSystem(sprintf('git rev-parse --verify %s', snapshotSpecifier));
            if status == 0
                exists = true;
                return;
            end
            exists = false;
        end
    end

    methods (Access=private)
        %% Metadata Storage for Project State Saving
        % When we check out snapshots, we are overwriting the entire working tree. So then where can we put the metadata
        % that describe where (which commit) we were earlier? By storing them in the Git objects database with
        % a ref pointing to it.
        function isPresent = isMetadataPresent(this)
            % Find out if metadata have been stored.
            % Do this by simply checking for the git ref that points to the metadata blob.
            isPresent = ~strcmp(this.getShaOfRef(GitSnapshotManager.METADATA_REF_NAME), '');
        end

        function writeMetadata(this, stringData)
            % Store metadata in the Git object database.
            % We store the metadata as a struct. To save it, we convert it to JSON, write it to a file, then
            % save that in the Git DB using hash-object, and finally set the ref GitSnapshotManager.METADATA_REF_NAME
            % to point to it.
            % There can only be one metadata object. This method throws an exception if there are already metadata
            % present.
            if this.isMetadataPresent()
                throw(MException(GitSnapshotManager.ERROR_METADATA_ALREADY_PRESENT, 'metadata already present'));
            end
            metadataTempFile = this.getMetadataTempFileName();
            this.logger.debug(sprintf('saving metadata via temp file %s', metadataTempFile));
            fileID = fopen(metadataTempFile, 'w', 'n', 'utf-8');
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

        function stringData = readMetadata(this)
        % Read the metadata stored by writeMetadata and return them as raw text.
        % If there are none present, throw an exception with the identifier ERROR_NO_METADATA_PRESENT
            if ~this.isMetadataPresent()
                throw(MException(GitSnapshotManager.ERROR_NO_METADATA_PRESENT, 'no metadata present'));
            end
            blobHash = this.getShaOfRef(GitSnapshotManager.METADATA_REF_NAME);

            [status, cmdout] = SystemUtil.safeSystem(sprintf('git cat-file -p %s', blobHash));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
            stringData = cmdout;
        end

        function deleteMetadata(this)
            % Delete the saved state metadata by deleting the tag. The blob will be garbage collected eventually.
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git update-ref -d %s', GitSnapshotManager.METADATA_REF_NAME));
            if (status ~= 0)
                throw(this.genericGitError(cmdout));
            end
        end

        function filename = getMetadataTempFileName(~)
            % The metadata have to be written to a temp file and the file then stored with hash-object. This method
            % gets the temp file's name.
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            filename = fullfile(speedtrackerConfig.tempDir, GitSnapshotManager.METADATA_TEMP_FILE_NAME);
        end

        function [headCommitSha, tempCommitSha] = saveWorkdirToTempCommit(this)
            % Save all current changes in the working directory to a temporary commit.
            % Must not be run if there are staged changes - the caller has to ensure this!
            % Returns the SHA of the previous commit, so we know what commit to `git reset --mixed` to when restoring.

            % get last commit SHA
            headCommitSha = this.getCurrentCommitSha();

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

            % get temp commit SHA
            tempCommitSha = this.getCurrentCommitSha();
        end

        function message = getTempCommitMessage(~)
            % The commit message for the temp commit that stores the working tree state
            message = 'speedtracker current state temp commit';
        end

        %% Snapshot ID format
        function isValid = isValidSnapshotID(~, id)
            % Given a 1xN char or a 1x1 string, determine if it is a valid snapshot name
            % It must match GitSnapshotManager.SNAPSHOT_ID_REGEX.
            % See also SNAPSHOT_ID_REGEX
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
            % Return 1 if there are no staged changes and 0 if there are.
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

        function isSha = isCommitSha(this, sha)
            % Return true if there is a commit whose SHA matches the provided value.
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

        function exists = commitExists(~, str)
            % Check if a string points to a commit (i.e. is a ref or SHA) 
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git cat-file -t %s', str));
            exists = (status == 0) && (strcmp(cmdout, 'commit'));
        end

        function sha = getCurrentCommitSha(this)
            % Get the SHA of the commit that HEAD is pointing to.
            [status, cmdout] = SystemUtil.safeSystem('git rev-parse --verify HEAD');
            if (status == 1)
                throw(this.genericGitError(cmdout));
            end
            sha = cmdout;
        end

        function checkoutCommit(this, commit)
            % Check out a commit. Works with any string that Git accepts as a revision specifier.
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git checkout %s', commit));
            if status ~= 0
                throw(this.genericGitError(cmdout));
            end
        end
        function err = genericGitError(~, cmdout)
            % Return a generic exception for when a Git command went wrong in an unexpected way.
            % This should never be used for actual, expected error conditions. Only in cases where it
            % _should_ be impossible for anything to go wrong - but you know how it is: we make mistakes,
            % we don't know when exactly a Git command may return an error, etc. - include a check for error
            % conditions and throw one of these so the error doesn't disappear silently.
            err = MException(GitSnapshotManager.ERROR_GIT_GENERIC, sprintf('error in Git command: %s', cmdout));
        end

        function info = getCommitInfo(this, sha)
            % Get info about a commit, returning an optionlist (see utils/optionlist/olIsOptionlist.m)
            % Properties:
            %   Author: the commit's author (Name <e@mail.address>)
            %   AuthorDate: author date (the one that governs which order snapshots are returned in) in Unix
            %     time (string)
            %   AuthorTimeZone: time zone of the author date, in the format +0100
            %   CommitDate: commit date in Unix time (string)
            %   CommitTimeZone: time zone of the commit date, in the format +0100
            %   Subject: the 'subject line', containing the commit message and some other stuff (and not necessarily
            %     only one line long!)
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
            info = { ...
                'Author', author, ...
                'AuthorDate', authorDate, ...
                'AuthorTimeZone', authorTimeZone, ...
                'CommitDate', commitDate, ...
                'CommitTimeZone', commitTimeZone, ...
                'Subject', subject ...
            };
        end

        %% Snapshot Storage
        % Each snapshot is a struct consisting of ID (name given by user), commit SHA, and timestamp, with the keys
        % `id`, `sha`, and `timestamp`, respectively. The latter
        % property is to facilitate sorting them by date, allowing them to be tested in the order their commits were
        % created: this is the obvious order, since we want to see whether IFDIFF's performance has degraded _over
        % time_. A set of snapshots is passed around as a vector array of these structs.
        % For storage, we simply write each snapshot on a line with id, sha, and timestamp separated by spaces.

        function filename = getSnapshotsFileName(~)
            % Get the filename for the snapshot file.
            % Note: this is the file in the original
            % speedtracker directory, not the temp dir! Only use this file for snapshot CRUD.
            % loadSnapshot uses getSnapshotsTempFileName instead.
            % See also GETSNAPSHOTSTEMPFILENAME
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig(); 
            filename = fullfile(speedtrackerConfig.speedtrackerDir, GitSnapshotManager.SNAPSHOTS_FILE_NAME);
        end

        function filename = getSnapshotsTempFileName(~)
            % Get the filename for the temp copy of the snapshot file.
            % Needed when loading snapshots, because the original will be overwritten by loading snapshots.
            % For snapshot CRUD, only use getSnapshotsFileName.
            %See also GETSNAPSHOTSFILENAME
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig(); 
            filename = fullfile(speedtrackerConfig.tempDir, GitSnapshotManager.SNAPSHOTS_FILE_NAME);
        end

        function snapshots = loadSnapshots(this, file)
            % Read a snapshot file and return a snapshot list. If it does not exist, return an empty array.
            % throw GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS if the file cannot be opened/written
            %   and GitSnapshotManager.ERROR_BAD_SNAPSHOTS_FILE if the file cannot be parsed.
            if ~exist(file, 'file')
                snapshots = [];
                return;
            end
            fid = fopen(file, 'r', 'n', 'utf-8');
            if fid == -1
                throw(MException(GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS, sprintf( ...
                    'snapshot file exists, but could not be read: %s', file)));
            end
            text = fread(fid, [1 inf], '*char');
            fclose(fid);
    
            lines = splitlines(text);
            lines = lines(~startsWith(lines, '#'));
            lines = lines(strlength(lines) > 0);
            snapshots(length(lines)) = this.makeSnapshotStruct('', '', 0);
            for i=1:length(lines)
                words = strsplit(lines{i});
                if length(words) ~= 3
                    throw(MException(GitSnapshotManager.ERROR_BAD_SNAPSHOTS_FILE, ...
                        sprintf('snapshot #%d in %s is malformed %s', i, file, lines(i))));
                end
                snapshots(i) = this.makeSnapshotStruct(words(1), words(2), str2double(words(3)));
            end
        end

        function saveSnapshots(~, snapshots, file)
            % Save snapshots, given as an array of structs, to a snapshot file. If the array is empty, delete the file.
            % throw GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS if the snapshot file cannot be accessed
            if (isempty(snapshots))
                try
                    delete(file);
                    return;
                catch fileError
                    error = MException(GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS, ...
                        sprintf('error accessing snapshot file: %s', fileError.message));
                    throw(error.addCause(fileError));
                end
            end
            lines = cell(1, length(snapshots));
            for i = 1:length(snapshots)
                snapshot = snapshots(i);
                lines{i} = strjoin({snapshot.id, snapshot.sha, sprintf('%d', snapshot.timestamp)}, ' ');
            end

            output = strjoin(lines, SystemUtil.lineSep());
            fid = fopen(file, 'w', 'n', 'utf-8');
            if fid == -1
                throw(MException(GitSnapshotManager.ERROR_SNAPSHOTS_FILE_ACCESS, sprintf( ...
                    'error opening or writing snapshot file: %s', file)));
            end
            fprintf(fid, '%s', output);
            fclose(fid);
        end

        function snapshotStruct = makeSnapshotStruct(~, id, sha, timestamp)
            snapshotStruct = struct('id', id, 'sha', sha, 'timestamp', timestamp);
        end

        function snapshot = getSnapshotById(~, snapshots, id)
            % Given an array of snapshots, find the one whose ID matches the supplied value.
            % Return [] if none match. Throw an exception if multiple match.
            indices = arrayfun(@(snapshot) strcmp(snapshot.id, id), snapshots);
            if isempty(indices(indices))
                snapshot = [];
            elseif length(indices(indices)) ~= 1
                throw(MException(GitSnapshotManager.ERROR_ILLEGAL_STATE, sprintf('multiple snapshots with ID %s', id)));
            else
                snapshot = snapshots(indices);
            end
        end

        %% Miscellaneous
        function seconds = getWaitTimeForLoading(this)
            % How long we must wait before the next snapshot loading operation, in seconds
            secondsSinceLastLoad = this.getPosixTime() - this.lastSnapshotLoadTime;
            seconds = GitSnapshotManager.SNAPSHOT_LOAD_WAIT_TIME - secondsSinceLastLoad;
        end
        function seconds = getPosixTime(~)
            seconds = posixtime(datetime('now', 'TimeZone', '+0000'));
        end

        function sha = resolveSnapshotSha(this, snapshotSpecifier)
            % Given a snapshot specifier, determine what commit it refers to.
            % There are three cases, which are checked in order
            % 1. the snapshot specifier is 'current' or 'worktree'. The SHA should capture the state of the working
            %   tree when speedtracker was invoked. If there were uncommitted changes, they were saved in a temp commit
            %   which we can use. If there were none, we can use the head commit at the time of invocation.
            % 2. the snapshot specifier is the ID of a snapshot saved with createSnapshot. We can find the commit in
            %   GSM's snapshots file.
            % 3. the snapshot specifier refers to a Git revision, either by being a literal commit SHA, a Git ref,
            %   or another identifier like HEAD, HEAD~, HEAD^, etc.
            % If none of these apply, return the empty string.
            %
            % Can only be called after saveProjectState, because describing the current state
            % *including uncommitted changes* with a commit is impossible until it is saved with saveProjectState.
            if this.isSpecialSnapshotName(snapshotSpecifier)
                metadataString = this.readMetadata();
                metadata = jsondecode(metadataString);
                if isfield(metadata, 'tempCommitSha')
                    sha = metadata.tempCommitSha;
                else
                    sha = metadata.headCommitSha;
                end
                return;
            end
            if this.isValidSnapshotID(snapshotSpecifier)
                snapshots = this.loadSnapshots(this.getSnapshotsTempFileName());
                snapshot = this.getSnapshotById(snapshots, snapshotSpecifier);
                if ~isempty(snapshot)
                    sha = snapshot.sha;
                    return;
                end
            end
            currentCommitSha = this.getCurrentCommitSha();
            metadataString = this.readMetadata();
            metadata = jsondecode(metadataString);
            headCommitSha = metadata.headCommitSha;
            this.checkoutCommit(headCommitSha);
            % attempt to dereference the revision specifier with Git
            [status, cmdout] = SystemUtil.safeSystem(sprintf('git rev-parse --verify %s', snapshotSpecifier));
            sha = cmdout;
            this.checkoutCommit(currentCommitSha);
            if status ~= 0
                sha = '';
            end
        end
        function isit = isSpecialSnapshotName(~, snapshotSpecifier)
            % Return true if a string/char is a _special snapshot_ name
            % The special names as of now are 'current' and 'worktree', both meaning "run the benchmarks with the
            % current state of the working tree (including uncommitted changes)".
            isit = strcmp(snapshotSpecifier, 'current') || strcmp(snapshotSpecifier, 'worktree');
        end
    end
end