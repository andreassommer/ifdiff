classdef (Abstract) SnapshotLoader
    %SNAPSHOTLOADER interface for loading snapshots, i.e. other versions of a project (think Git commits)

    properties (Constant)
        ERROR_COULD_NOT_SAVE_STATE = 'SnapshotLoader:couldNotSaveState';
        ERROR_NO_SAVED_STATE = 'SnapshotLoader:noSavedStateFound';
        ERROR_SAVED_STATE_PRESENT = 'SnapshotLoader:savedStatePresent';
        ERROR_BAD_SNAPSHOT_ID = 'SnapshotLoader:badSnapshotID';
        ERROR_COULD_NOT_LOAD_STATE = 'SnapshotLoader:couldNotLoadState';
    end
    methods (Abstract)
        % Save the current state of the project directory persistently to prepare for checking out snapshots.
        % Then loadSnapshot can be called to check out snapshots.
        % Must guarantee:
        % 1. to throw an exception if anything went wrong when saving the state
        % 2. to leave the project in its original state if anything went wrong when saving the state
        % Should throw the following exception identifiers in the given cases:
        % ERROR_SAVED_STATE_PRESENT if there is already a saved state present
        % ERROR_COULD_NOT_SAVE_STATE if something else went wrong saving the state
        % Implementation-specific errors can be attached as causes.
        this = saveProjectState(this)
        % Load the specified snapshot. The project state must have been saved with saveProjectState first.
        % A snapshot may be loaded while another one is checked out, the only rule is that the original state
        % has to have been saved. Make sure to handle errors carefully in your snapshot-checking-out-and-testing
        % code so that you can call restoreProjectState no matter what goes wrong.
        %
        % You may have to write your implementation to wait a second between snapshot check-outs, because
        % MATLAB does not seem to understand that a file has changed unless at least a second passed since
        % the last change (not a full second - the seconds fields of the timestamps must differ). If you find
        % another way to ensure that MATLAB is always running the current version of your code, then you can use
        % that, of course.
        % Should throw the following exception identifiers in the given cases:
        % ERROR_NO_SAVED_STATE if there is no saved state present (saveProjectState() was not called)
        % May also throw:
        % ERROR_BAD_SNAPSHOT_ID, e.g. if a snapshot does not exist or the name violates the implementation's
        %     rules for ID syntax.
        % Implementation-specific errors can be attached as causes.
        this = loadSnapshot(this, id)
        % Restore the state of the project from the saved data created by saveProjectState
        % You may have to write your implementation to wait a second after the last snapshot check-out, because
        % MATLAB does not seem to understand that a file has changed unless at second passed since
        % the last change (not a full second - the 'seconds' fields of the timestamps must differ). If you find
        % another way to ensure that MATLAB is always running the current version of your code, then you can use
        % that, of course.
        % Must guarantee:
        % R1 The state can be restored statelessly, using only the same subclass - not instance - of
        %     SnapshotLoader. This way, even if the program crashes, you can construct a new SnapshotLoader and restore
        %     the state without needing any data that were in the RAM of the crashed process.
        % Should throw the following exception identifiers in the given cases:
        %     ERROR_NO_SAVED_STATE if there is no saved state to load
        %     ERROR_COULD_NOT_LOAD_STATE if something else went wrong loading the state
        % Implementation-specific errors can be attached as causes.
        this = restoreProjectState(this)
    end
end