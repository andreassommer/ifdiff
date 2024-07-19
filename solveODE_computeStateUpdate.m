function solveODE_computeStateUpdate(datahandle)
    % Compute the starting time point, state, and signature
    % After a switching point t2 has been determined and the solution extended until t2, we can compare the
    % signatures before and after t2 and check if any of the switching ctrlifs has a jump associated with it.
    % If so, compute the appropriate jump function and link it to the SWP.
    data = datahandle.getData();

    t = data.SWP_detection.t2;
    xMinus = deval(data.SWP_detection.solution_until_t2, t);

    computeUpdateFunction(datahandle);
    data = datahandle.getData();

    if isempty(data.SWP_detection.jumpFunction{end})
        xPlus = xMinus;
    else
        incrementFunction = data.SWP_detection.jumpFunction{end};
        xPlus = xMinus + incrementFunction(datahandle, t, xMinus, data.SWP_detection.parameters);
    end

    data = datahandle.getData();
    data.SWP_detection.x2 = {xMinus, xPlus};

    % Get the new signature at t2, without forced branching
    [switch_cond, ctrlif_index, function_index] = ctrlif_getSignature(datahandle, t, xPlus);
    data.SWP_detection.signature.switch_cond{end+1} = switch_cond;
    data.SWP_detection.signature.ctrlif_index{end+1} = ctrlif_index;
    data.SWP_detection.signature.function_index{end+1} = function_index; 

    datahandle.setData(data);
end