function solveODE_setFilippovRHS(datahandle, sliding_switches)
    % Sets in datahandle.integratorSettings the field 'filippovRHS' to a
    % RHS that allows to slide/run on the zero-manifold associated to a
    % function that is inconsistently switching.
    %
    % INPUT:
    % 'datahandle':         datahandle containing the integration and 
    %                       switching data.
    %
    % 'sliding_switches':   Array of switches (ctrlif_indices) 
    %                       that switched during phase that is suspected to 
    %                       show inconsistent switching.
    %
    % OUTPUT:
    % No output. But datahandle is modified.
    %
    %
    % Author: Michael Strik, Jun2024
    % Email: michael.strik@stud.uni-heidelberg.de
    %        michi.strik@gmail.com

    % determine where to go back
    t = solveODE_backtrackChattering(datahandle);

    % cut steps
    % we integrated until t2 so far

    solution_until_t2 = datahandle.getData().SWP_detection.solution_until_t2;
    % x: time points
    x = solution_until_t2.x; 
    indices_x_greater_t = find(x>t);
    % cut off all that exceeds timepoint t
    k = length(indices_x_greater_t);
    solveODE_cutSteps_solution_until_t2(datahandle, k)

    % construct new RHS
    % Determine the chattering switch. If there's more than one, abort.
    sliding_switches = unique(sliding_switches);
    if length(sliding_switches) > 1
        error("Inconsistent switching includes more than one switch.")
    end
    sliding_ctrlif_index = sliding_switches(1);
    % get the chattering switch's switching function
    % We checked if the ctrlif_index was always the same, so we assume the
    % switching function is too and just pick the last one.
    switchingFunction = datahandle.getData().SWP_detection.switchingfunctionhandles{end};

    filippov_rhs = @(datahandle, t, y, p) slidingFilippovRHS_oneSwitch(datahandle, sliding_ctrlif_index, switchingFunction, t, y, p);
    % filippov_rhs = @(datahandle, t, y, p) fprintf("Filippov RHS.\n");

    % Update datahandle
    data = datahandle.getData();
    % set filippov rhs
    data.integratorSettings.filippov_rhs = filippov_rhs;
    % don't analyse signature during integration
    data.integratorSettings.optionsForcedBranching.OutputFcn = [];
    % memorize sliding switch: sliding_ctrlif_index is supposed to be 
    % ignored by checkForSwitchingIndices.m
    data.integratorSettings.filippov_ctrlif_index = sliding_ctrlif_index;
    datahandle.setData(data);

    % message
    fprintf("Switched to Filippov right-hand-side.\n");

end