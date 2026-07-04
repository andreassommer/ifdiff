function generateData(datahandle, sol)
% generateData(datahandle)
%
% Generates the data that is needed in many of the functions used for the sensitivity calculation 
% that is not changed over the time of the calculation. 
%
% INPUT: datahandle - datahandle you get from the integration process with solveODE
%        sol        - solution object from the integration with solveODE
%
% OUTPUT: None (The data is written into the datahandle)

    data = datahandle.getData();
    % Make sure that values stored in data match solution, since they may be overwritten by a solveODE call.
    data.SWP_detection.parameters = reshape(sol.parameters, [], 1);
    data.SWP_detection.signature = sol.signature;
    data.SWP_detection.tspan = [sol.x(1), sol.x(end)];
    data.SWP_detection.initialvalues = sol.y(:, 1);
    data.SWP_detection.switchingFunction = sol.switchingFunction;
    data.SWP_detection.jumpFunction = sol.jumpFunction;

    data.computeSensitivity.switches_extended = [data.SWP_detection.tspan(1), sol.switches, data.SWP_detection.tspan(end)];
    data.computeSensitivity.y_to_switches = deval(sol, data.computeSensitivity.switches_extended);

    % For every SWP that has a jump, we also set up a left-shifted version that we will later use for approximating
    % the left limit of y at that SWP.
    switchesLeftShifted = sol.switches;
    for i=1:length(sol.switches)
        if sol.jumps(i)
            swp = switchesLeftShifted(i);
            switchesLeftShifted(i) = leftLimit(swp);
        end
    end
    data.computeSensitivity.switches_extended_left = [data.SWP_detection.tspan(1), switchesLeftShifted, data.SWP_detection.tspan(end)];
    data.computeSensitivity.y_to_switches_left = deval(sol, data.computeSensitivity.switches_extended_left);

    data.computeSensitivity.dim_y = size(sol.y, 1);
    data.computeSensitivity.dim_p = length(data.SWP_detection.parameters);

    datahandle.setData(data);
end
