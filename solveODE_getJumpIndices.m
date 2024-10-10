function jumpCtrlifs = solveODE_getJumpIndices(datahandle)
%SOLVEODE_GETJUMPINDICES Get the switching indices of all jumps that apply to a switch.
% Just like with switching function computation, switching index is the index into the switch_cond, ctrlif_index,
% and function_index arrays. A switching index corresponds not to a ctrlif, but to one execution of a ctrlif.
    data = datahandle.getData();

    % First, get the ctrlif index and direction of all jumps
    if isfield(data.SWP_detection, 'jumpConditions')
        jumps = data.SWP_detection.jumpConditions;
    else
        jumps = getJumpIndices_getJumpConditions(datahandle);
        data.SWP_detection.jumpConditions = jumps;
        datahandle.setData(data);
    end

    jumpCtrlifs = [];
    if isempty(jumps)
        return;
    end

    % Then, collect the jumps that happen at this switching point. That means
    % 1. the ctrlif that they attach to has switched
    % 2. the switch was in the same direction as the jump's direction flag
    switchingIndices = getSwitchingIndices(datahandle, 0);
    for i=1:length(switchingIndices)
        sI = switchingIndices(i);
        ctrlif_index   = data.SWP_detection.ctrlif_index_t1(sI);
        switch_cond_t1 = data.SWP_detection.switch_cond_t1(sI);
        switch_cond_t2 = data.SWP_detection.switch_cond_t2(sI);
        jumpIndex = find(jumps(2, :) == ctrlif_index);
        if isempty(jumpIndex)
            continue;
        end
        % if the jump's direction (-1 | 0 | 1) matches the direction of the switch's zero crossing, add the jump
        % to the return array. Note that we are taking a shortcut here: we should be checking the switching
        % function's value before and after the jump. but since the ctrlif's condition is always of the form
        % <expr> >= 0 and the signature before/after the jump was obtained with forced branching, we can identify a
        % negative->positive jump with a transition from 0 to 1 and vice versa
        if jumps(1, jumpIndex) == 0 || jumps(1, jumpIndex) == (switch_cond_t2 - switch_cond_t1)
            jumpCtrlifs = [jumpCtrlifs sI];
        end
    end
end