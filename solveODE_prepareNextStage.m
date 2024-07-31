function solveODE_prepareNextStage(datahandle)
%SOLVEODE_PREPARENEXTSTAGE Compute the starting state and signature for the next stage after a switching point.
    data = datahandle.getData();

    t = data.SWP_detection.t2;
    xMinus = deval(data.SWP_detection.solution_until_t2, t);

    if isempty(data.SWP_detection.jumpFunction{end})
        xPlus = xMinus;
    else
        incrementFunction = data.SWP_detection.jumpFunction{end};
        increment = incrementFunction(datahandle, t, xMinus, data.SWP_detection.parameters);
        xSize = size(xMinus);
        incSize = size(increment);
        if length(xSize) ~= length(incSize) || any(xSize ~= incSize)
            error('switch at %f: dimensions of state increment do not match dimensions of state', t);
        end
        xPlus = xMinus + increment;
    end

    data.SWP_detection.x2 = {xMinus, xPlus};

    % Get the new signature at t2, without forced branching
    [switch_cond, ctrlif_index, function_index] = ctrlif_getSignature(datahandle, t, xPlus);
    data.SWP_detection.signature.switch_cond{end+1} = switch_cond;
    data.SWP_detection.signature.ctrlif_index{end+1} = ctrlif_index;
    data.SWP_detection.signature.function_index{end+1} = function_index; 

    datahandle.setData(data);
end