function Updates = getGy_Gp_update(datahandle, startModel, endModel, Gp_flag, options)
    % Updates = generateGmatrices_Updates(datahandle, amountG, modelNum, Gp_flag, options)
    %
    % Calculates the update-matrices for the sensitivitiy calculation with END_piecewise or VDE.
    %
    % INPUT: datahandle - datahandle you get from the integration process with solveODE
    %        amountG    - amount of intermediate G-matrices that already have been calculated and saved from previous function calls.
    %                     (If amountG = 1, it means that the intermediates were only initialised and all the matrices have still to be calculated.)
    %        modelNum   - number of the model until which the update-matrices need to be calculated
    %        Gp_flag    - flag that is true if the sensitivities with respect to the parameters should be calculated
    %        options    - struct that has the informations for the stepsizes for END, the integrator and the method
    %
    % OUTPUT: Updates - struct that has he update-matrices needed for the sensitivities w.r.t. y0 and optionally w.r.t. p

    % Initialize
    data = datahandle.getData();
    parameters = data.SWP_detection.parameters;
    switches = data.computeSensitivity.switches_extended;
    switches_left = data.computeSensitivity.switches_extended_left;
    y_to_switches      = data.computeSensitivity.y_to_switches;
    y_to_switches_left = data.computeSensitivity.y_to_switches_left;
    switching_functions = data.SWP_detection.switchingFunction;
    jump_functions      = data.SWP_detection.jumpFunction;
    functionRHS =  data.integratorSettings.preprocessed_rhs;

    FDstep = options.FDstep;

    dim_y = data.computeSensitivity.dim_y;
    dim_p = data.computeSensitivity.dim_p;
    unit = eye(dim_y);

    numModels = endModel - startModel;
    Updates.Uy_new = cell(1, numModels);

    if Gp_flag
        Updates.Up_new = cell(1, numModels);
        h_p = fdStep_getH_p(FDstep, parameters);
    end

    % Fix the model and set the model number for which model you want to evaluate the RHS
    data.computeSensitivity.modelStage = startModel;
    datahandle.setData(data);

    % Calculate the remaining update matrices for the update formula until modelNum.
    for i = startModel : (endModel-1)
        switchingFunction = switching_functions{i};
        jumpFunction      = jump_functions{i};
        y_to_switch_left = y_to_switches_left(:, i+1);
        y_to_switch = y_to_switches(:, i+1);
        switchingPoint = switches(i+1);
        switchingPoint_left = switches_left(i+1);

        h_y = fdStep_getH_y(FDstep, y_to_switch_left);
        h_t = fdStep_getH_t(FDstep, switchingPoint_left);

        % Calculate the derivatives of the switching functions w.r.t. y, t (and p if necessary)
        del_sigmay = del_f_del_y(datahandle, switchingFunction, switchingPoint_left, y_to_switch_left, parameters, h_y);
        del_sigmat = del_f_del_t(datahandle, switchingFunction, switchingPoint_left,  y_to_switch_left, parameters, h_t);
        diff_sigmat = del_sigmat + del_sigmay * functionRHS(datahandle, switchingPoint_left,  y_to_switch_left, parameters);
        if isempty(jumpFunction)
            del_jumpy = zeros(dim_y);
            del_jumpt = zeros(dim_y, 1);
        else
            del_jumpy = del_f_del_y(datahandle, jumpFunction, switchingPoint_left, y_to_switch, parameters, h_y);
            del_jumpt = del_f_del_t(datahandle, jumpFunction, switchingPoint_left, y_to_switch, parameters, h_y);
        end

        % Evaluate the RHS at the switching point first with the model fixed on the left of the switch, then increase the model number
        % and evalate the RHS with the model fixed on the left of the switch. 
        fminus = functionRHS(datahandle, switchingPoint_left, y_to_switch_left, parameters);

        data = datahandle.getData();
        data.computeSensitivity.modelStage = data.computeSensitivity.modelStage + 1;
        datahandle.setData(data);

        fplus = functionRHS(datahandle, switchingPoint, y_to_switch, parameters);

        % Calculate the updates according to the update formula 
        Updates.Uy_new{i} = unit + del_jumpy + (fplus - (del_jumpt + (unit+del_jumpy)*fminus)) * del_sigmay / diff_sigmat;

        if Gp_flag
            del_sigmap = del_f_del_p(datahandle, switchingFunction, switchingPoint_left, y_to_switch_left, parameters, h_p);
            if isempty(jumpFunction)
                del_jumpp = zeros(dim_y, dim_p);
            else
                del_jumpp = del_f_del_p(datahandle, jumpFunction, switchingPoint_left, y_to_switch_left, parameters, h_p);
            end
            Updates.Up_new{i} = del_jumpp + (fplus - (del_jumpt + (unit+del_jumpy)*fminus)) * del_sigmap / diff_sigmat;
        end
    end
end