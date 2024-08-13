function Gp = generateGmatrices_Gp(datahandle, sol, sensData, Gmatrices_intermediate, options)
% Gp = generateGmatrices_Gp(datahandle, sol, sensData, Gmatrices_intermediate, options)
%
% Calculates the sensitivities w.r.t. p at the given timepoints by putting together the already calculated intermediate matrices
% and the updates with the here calculated G-matrix which is the sensitivity at the timpoint t
% (t stands for the timpoints at which the sensitivities should be calculated)
% while the starting point is the preceding swtiching point (called ts) or t0 if the timepoint is before the first switch.
%
% INPUT: datahandle             - datahandle you get from the integration process with solveODE
%        sol                    - solution object from the integration with solveODE
%        sensData               - struct array that contains the timepoints, the modelNum and the sensitivities at the given timepoints w.r.t. y0 and p
%        Gmatrices_intermediate - struct that contains the already calculated intermediates and updates w.r.t. y0 and p
%        options                - struct that has the informations for the stepsizes for END, the integrator and the method
%
% OUTPUT: Gp - cell-array that contains the sensitivities at the given timepoints w.r.t. p
   
    % Initialize
    data = datahandle.getData();
    parameters = data.SWP_detection.parameters;
    timepoints = sensData.timepoints;
    switches = data.computeSensitivity.switches_extended;
    y_to_switches = data.computeSensitivity.y_to_switches;
    modelNum = sensData.modelNum;
    integrator = options.integrator;
    integrator_options = options.integrator_options;
    
    functionRHS = data.integratorSettings.preprocessed_rhs;
    functionRHS_simple_END = data.computeSensitivity.functionRHS_simple_END;
    functionRHS_simple_VDE = data.computeSensitivity.functionRHS_simple_VDE;
    
    dim_y = data.computeSensitivity.dim_y;
    dim_p = data.computeSensitivity.dim_p;
    unit_p = eye(dim_p);
    
    eval_disturb_p = cell(1, dim_p);
    Gp_t_ts = cell(1, length(timepoints));
    
    % Fix the model and set the model number for which model you want to evaluate the RHS
    data.computeSensitivity.modelStage = modelNum;
    datahandle.setData(data);
    
    tspan_new = [switches(modelNum), timepoints(end)];
    
    if options.method == options.methodCoded.END_piecewise
 
        % Calculate the G-matrix Gp_t_ts for the update formula using a simple integrator for solving ODEs (e.g. ode45)
        FDstep = options.FDstep;
        h_p = fdStep_getH_p(FDstep, parameters);
        
        y_start = y_to_switches(:, modelNum);
        sol_original = integrator(functionRHS_simple_END, tspan_new, y_start, integrator_options);
        y  = repmat(deval(sol_original,timepoints), [1, dim_p]);
     
        % Cycle through every parameter and compute the sensitivites
        for j=1:dim_p
            parameters_new = parameters + h_p.*unit_p(:,j);
            functionRHS_simple_disturb = @(t,y) functionRHS(datahandle, t, y,  parameters_new);
            sol_disturb = integrator(functionRHS_simple_disturb, tspan_new, y_start, integrator_options);
            
            eval_disturb_p{j} = deval(sol_disturb,timepoints);
        end
     
        difference = reshape((cell2mat(eval_disturb_p) - y), [], dim_p);
        
        count = 1 : dim_y : size(difference, 1);
        for i = 1:length(timepoints)
            Gp_t_ts{i} = difference(count(i):i*dim_y, 1:dim_p)./reshape(h_p, 1, []);
        end
        if timepoints(1) == switches(modelNum)
            % Gp(t_0, t_0)=0. But since we apply our h-disturbance to the initial values, our solution will not reflect
            % this. Here, we correct this case.
            Gp_t_ts{1} = zeros(dim_y, dim_p);
        end
    else
     
        % Calculate the G-matrix Gp_t_ts for the update formula using variational differential equations
        
        function_p_VDE = @(t,G) VDE_RHS_p(sol, functionRHS_simple_VDE, t, G, parameters, options);
        initial_p = reshape(zeros(dim_y,dim_p), [], 1);
        
        solVDE = integrator(function_p_VDE, tspan_new, initial_p, integrator_options);
        diff_y_p_sol = deval(solVDE, timepoints);
     
        for i = 1:length(timepoints)
            Gp_t_ts{i} = reshape(diff_y_p_sol(:,i), dim_y, []);
        end
    end

    % Calculate the G-matrix Gp_t_t0 according to the update formula
    Uy = Gmatrices_intermediate.Uy;
    Up = Gmatrices_intermediate.Up;
    Gp_intermediate = Gmatrices_intermediate.Gp;
    Gy_t_ts = sensData.Gy_t_ts;

    Gp = cell(1, length(timepoints));
    if modelNum == 1
        Gp = Gp_t_ts;
    else
        for i = 1:length(timepoints)
            Gp{i} = Gy_t_ts{i} * (Uy{modelNum} * Gp_intermediate{modelNum} + Up{modelNum}) + Gp_t_ts{i};
        end
    end
end