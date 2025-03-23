function solveODE_setFilippovRHS(datahandle)
    % Sets datahandle.sliding.filippovRHS to a RHS that allows to slide/run 
    % on the zero-manifold associated to a function that is inconsistently switching.
    %
    % INPUT:
    % 'datahandle':         datahandle containing the integration and 
    %                       switching data.
    %
    % OUTPUT:
    % No output.
    %
    %
    % Author: Michael Strik, Jun2024
    % Email: michael.strik@stud.uni-heidelberg.de
    %        michi.strik@gmail.com

    % determine where to go back
    [t, chattering_indices] = solveODE_backtrackChattering(datahandle);
    chattering_indices = unique(chattering_indices);
    if length(chattering_indices) > 1
        % exclude the case that several switches chatter
        error("Inconsistent switching includes more than one switch.")
    end
    sliding_index = chattering_indices(1);

    % cut steps
    % we integrated until t2 so far
    solution_until_t2 = datahandle.getData().SWP_detection.solution_until_t2;
    x = solution_until_t2.x; % x: time points
    indices_x_greater_t = find(x>t);
    % cut off all that exceeds timepoint t
    k = length(indices_x_greater_t);
    solveODE_cutSteps_solution_until_t2(datahandle, k)

    % get the chattering switch's switching function
    switchingFunction = datahandle.getData().SWP_detection.switchingfunctionhandles{end};
    % We checked if there was a single switch active during chattering, 
    % so we just pick the switching function of the last switching event.

    % activate forced branching and set RHS
    data = datahandle.getData();
    t = data.SWP_detection.solution_until_t2.x(end);
    x = deval(data.SWP_detection.solution_until_t2, data.SWP_detection.solution_until_t2.x(end)); 
    ctrlif_setForcedBranchingSignature(datahandle, t, x);
    filippov_rhs = @(datahandle, t, y, p) slidingFilippovRHS_oneSwitch(datahandle, sliding_index, switchingFunction, t, y, p);

    % Update datahandle
    data = datahandle.getData();
    % set filippov rhs
    data.sliding.filippov_rhs = filippov_rhs;
    data.sliding.index = sliding_index;
    data.sliding.ctrlif_index  = data.forcedBranching.ctrlif_index(sliding_index);
    data.sliding.function_index = data.forcedBranching.function_index(sliding_index);
    datahandle.setData(data);

    % message
    fprintf("Entered Filippov regime.\n");

end