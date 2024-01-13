classdef (Abstract) SnapshotLoader
    %SnapshotManager Abstract class for loading snapshots

    properties (Constant)
        ERROR_COULD_NOT_SAVE_STATE = "SnapshotLoader:couldNotSaveState";
        ERROR_NO_SAVED_STATE = "SnapshotLoader:noSavedStateFound";
        ERROR_SAVED_STATE_PRESENT = "SnapshotLoader:savedStatePresent";
        ERROR_BAD_SNAPSHOT_ID = "SnapshotLoader:badSnapshotID";
        ERROR_COULD_NOT_LOAD_STATE = "SnapshotLoader:couldNotLoadState";
    end
    methods (Abstract)
        % Save the current state of the project to a temporary snapshot. Then loadSnapshot can be called to
        % switch to a snapshot.
        % Must guarantee:
        % 1. to throw an exception if anything went wrong creating the temporary snapshot
        % 2. to leave the project in its original state if anything went wrong creating the temporary snapshot
        % Should throw the following exception identifiers in the given cases:
        % ERROR_SAVED_STATE_PRESENT if there is already a saved state present
        % ERROR_COULD_NOT_SAVE_STATE if something else went wrong saving the state
        % Implementation-specific errors can be attached as causes.
        saveProjectState(this)
        % Load the specified snapshot. The project state must have been saved with saveProjectState first.
        % A snapshot may be loaded while another one is checked out, the only rule is that the original state
        % has to have been saved. Make sure to put your snapshot-checking-out-and-testing code in try blocks
        % so that you can call restoreProjectState no matter what happens.
        % Should throw the following exception identifiers in the given cases:
        % ERROR_NO_SAVED_STATE if there is no saved state present (saveProjectState() was not called)
        % May also throw:
        % ERROR_BAD_SNAPSHOT_ID, e.g. if a snapshot does not exist or the name violates the implementation's
        %     rules for ID syntax.
        % Implementation-specific errors can be attached as causes.
        loadSnapshot(this, id)
        % Restore the state of the project from the temporary snapshot created by saveProjectState and
        % delete the temp snapshot.
        % Must guarantee:
        % 1. The snapshot can be restored statelessly, using only the same subclass - not instance - of
        %     SnapshotManager. This is to minimize the likelihood that restoring the state becomes impossible
        % Should throw the following exception identifiers in the given cases:
        %     ERROR_NO_SAVED_STATE if there is no saved state to load
        %     ERROR_COULD_NOT_LOAD_STATE if something else went wrong loading the state
        % Implementation-specific errors can be attached as causes.
        restoreProjectState(this)
        % List all available snapshots in a struct with the following fields:
        % id: snapshots' unique IDs
        % time: A representation of the snapshot's time. This does not mean when the snapshot was
        %    created, but rather when the project state it represents was current. An ascending ordering of
        %    these timestamps should be equivalent to the temporal order of the snapshots' project states. This aspect
        %    is the only requirement. Apart from that, it can be anything - Unix timestamps, date strings,
        %    an ascending counter, whatever.
        % Note that this is not an array of structs, but a single struct with vectorial fields. It may contain
        % additional fields.
        snapshots = listSnapshots(this)
    end
end