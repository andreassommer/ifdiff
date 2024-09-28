function forcedBranching = initDatahandleFields_forcedBranching()
% FORCEDBRANCHING fields for the forced branching stage

    % The original model's signature
    forcedBranching.switch_cond_forcedBranching    = [];
    forcedBranching.ctrlif_index_forcedBranching   = [];
    forcedBranching.function_index_forcedBranching = {};

    % After every integration step, the current model's signature is stored in these three fields.
    % Comparing these to xyz_forcedBranching allows detecting that a switch has occurred
    forcedBranching.switch_cond    = {};
    forcedBranching.ctrlif_index   = {};
    forcedBranching.function_index = {};

    forcedBranching.ctrlifCounter = 0;
end