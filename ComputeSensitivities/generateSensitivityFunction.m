function sensitivities_function = generateSensitivityFunction(datahandle, sol, FDstep, varargin)
   % sensitivities_function = generateSensitivityFunction(datahandle, sol, FDstep, varargin)
   %
   % Generates a function that can take a vector of timepoints and the struct FDstep with the stepsizes for END as inputs 
   % and calculates the sensitivities at the given timepoints. Here the user can specify his requirements to the generated function.
   % The methods possible for the calculation of sensitivities are END_full, END_piecewise or VDE.
   % The calculation of the sensitivities at the timepoint of a switch is onyl possible using the methods END_piecewise or VDE.
   % Therefore we look at the function y(t) as cadlag ("right continuous with left limits") and the calculation is possible using the updates.
   %
   % INPUT: datahandle - datahandle you get from the integration process with solveODE
   %        sol        - solution object from the integration with solveODE
   %        FDstep     - struct that contains the stepsizes for calcualtion of derivatives with END (External numerical differentiation)
   %        varargin   - optional specification of certain parameters:
   %                     'integrator'             - integrator for computing the END and solve the VDE
   %                     'integrator_options'     - integrator options for computing the END and solve the VDE
   %                     'calcGy'                 - flag that is true if the sensitivities w.r.t. the initial values should be calculated
   %                     'calcGp'                 - flag that is true if the sensitivities w.r.t. the parameters should be calculated
   %                     'save_intermediates'     - flag that is true if the intermediate G-matrices and updates that have been calculated for END_piecewise 
   %                                                or VDE should be saved for the next function call for computing sensitivities
   %                     'Gmatrices_intermediate' - flag that is true if the intermediate G-matrices that have been calculated for END_piecewise 
   %                                                or VDE should be included in the output struct
   %                     'method'                 - method that should be used to calculate the sensitivities (you can choose from END_full, 
   %                                                END_piecewise and VDE)
   %                     'directions_y'           - matrix that contains the directions in which you want to calculate the sensitivities w.r.t. y0 if you use END_full
   %                     'directions_p'           - matrix that contains the directions in which you want to calculate the sensitivities w.r.t. p if you use END_full
   %
   % OUTPUT: sensitivities_function - function that that can take a vector of timepoints and the struct FDstep with the stepsizes for END 
   %                                  as inputs and calculates the sensitivities at the given timepoints.

   sensitivities_function = @computeSensitivities;
   
   generateData(datahandle, sol);
   data = datahandle.getData();

   % default settings
   integrator                  = data.integratorSettings.numericIntegrator;
   integrator_options          = data.integratorSettings.options;
   method                      = 'VDE';
   Gmatrices_intermediate_flag = false;
   Gy_flag                     = true;
   directions_y                = 0;
   Gp_flag                     = true;
   directions_p                = 0;
   save_intermediates          = true;

   if olHasOption(varargin, 'integrator'),                 integrator = olGetOption(varargin, 'integrator'); end
   if olHasOption(varargin, 'integrator_options'), integrator_options = olGetOption(varargin, 'integrator_options'); end
   if olHasOption(varargin, 'calcGy'),                        Gy_flag = olGetOption(varargin, 'calcGy'); end
   if olHasOption(varargin, 'calcGp'),                        Gp_flag = olGetOption(varargin, 'calcGp'); end
   if olHasOption(varargin, 'method'),                         method = olGetOption(varargin, 'method'); end
   if olHasOption(varargin, 'Gmatrices_intermediate')
                                        Gmatrices_intermediate_flag = olGetOption(varargin, 'Gmatrices_intermediate');
   end
   if olHasOption(varargin, 'save_intermediates'), save_intermediates = olGetOption(varargin, 'save_intermediates'); end
   if olHasOption(varargin, 'directions_y'),             directions_y = olGetOption(varargin, 'directions_y'); end
   if olHasOption(varargin, 'directions_p'),             directions_p = olGetOption(varargin, 'directions_p'); end
   
   methodCoded.END_piecewise = 1;
   methodCoded.VDE           = 2;
   methodCoded.END_full      = 3;
   
   if strcmpi(method, 'END_piecewise'),method = methodCoded.END_piecewise; end
   if strcmpi(method, 'VDE'),          method = methodCoded.VDE; end
   if strcmpi(method, 'END_full'),     method = methodCoded.END_full; end
   
   % switches includes tspan(1) and tspan(end)
   switches      = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;
   
   tspan = data.SWP_detection.tspan;
   dim_y = data.computeSensitivity.dim_y;
   dim_p = data.computeSensitivity.dim_p;

   options.FDstep = FDstep;
   options.integrator = integrator;
   options.integrator_options = integrator_options;
   options.method = method;
   options.methodCoded = methodCoded;
 
   Gmatrices_intermediate_template.Gy = {eye(dim_y)};
   Gmatrices_intermediate_template.Uy = {eye(dim_y)};
   Gmatrices_intermediate_template.Gp = {zeros(dim_y, dim_p)};
   Gmatrices_intermediate_template.Up = {zeros(dim_y, dim_p)};
   return
   
   function sensitivities = computeSensitivities(t_all)
       if ~Gy_flag && ~Gp_flag
           return;
       end
      % sensitivities = computeSensitivities(t_all)
      % 
      % Calculates the sensitivities w.r.t. y0 and p at the given timepoints.
      %
      % INPUT: t_all  - vector of timepoints at which you want to calculate the sensitivities
      %
      % OUTPUT: sensitivities - struct that contains the given timepoints, the calculated sensitivities and the intermediate G-matrices
   
      [t_sort_unique, ~, unique_indices] = unique(t_all);
      
      if t_sort_unique(1) < tspan(1) || t_sort_unique(end) > tspan(end)
         error('Time point is outside of the time interval of the IVP solution.')
      end

      config = makeConfig();
      data = datahandle.getData();
      data.caseCtrlif = config.caseCtrlif.computeSensitivities;
      datahandle.setData(data);

      Gmatrices_intermediate = Gmatrices_intermediate_template;

      if method == methodCoded.END_full
          sensitivities = compute_sensitivity_ENDfull(datahandle, t_sort_unique, sol, FDstep, Gy_flag, Gp_flag, directions_y, directions_p, Gmatrices_intermediate);
          sensitivities = sensitivities(unique_indices);
      elseif method == methodCoded.END_piecewise
            % The unique timepoints are separated into groups according to their model number, that means all time points that are between the same
            % two switching points are in one group. If one group is empty (so no timepoint is given between two switching points), 
            % the group is left empty and will be skipped in the calculations later. 
            switches_temp = switches;
            switches_temp(end) = switches_temp(end) + eps(switches_temp(end));
            amountGroups = length(switches) - 1;
            timeGroups = cell(1, amountGroups);
      
            for i = 1:length(switches)-1
                indices = (t_sort_unique >= switches_temp(i)) & (t_sort_unique < switches_temp(i+1));
                timeGroups{i} = t_sort_unique(indices);
            end

            % sensData is a struct array that is as long as the amount of the time groups and every index belongs to one group
            sensData = generateSensData(amountGroups);

            % The latest timepoint is being extracted to know how many intermediate matrices need to be calculated because they are needed until 
            % the last switch before the latest timepoint. 
            t_max = t_sort_unique(end);
            modelNum = find(t_max < switches_temp, 1) - 1;
            
            % if the method END_full has been chosen before, the data for the sensitivity generation needs to be generated again here.
            generateData(datahandle, sol);

            % G(ts2, ts1) at the end of each model stage
            Gy_new = cell(1, modelNum);
            % One element for each model stage; this has one element per time point, and these in turn have y_dim x
            % y_dim elements. Whew!
            Gy_t_ts = cell(1, modelNum);
            for i=1:modelNum
                y_start = y_to_switches(:, i);
                h_y = fdStep_getH_y(FDstep, y_start);
                tspan_new = [switches(i), switches(i+1)];
                [sol_original, sols_disturbed] = solveDisturbed_Gy(datahandle, tspan_new, i, y_start, h_y, options);
                y  = deval(sol_original, switches(i+1));
 
                eval_disturb_y0 = zeros(dim_y);
                for j=1:dim_y
                    sol_disturb = sols_disturbed{j};
                    eval_disturb_y0(:,j) = deval(sol_disturb, switches(i+1));
                end
                Gy_new{i} = (eval_disturb_y0 - y)./ reshape(h_y, 1, []);
            end
            for i=1:modelNum
                timepoints = timeGroups{i};
                tspan_new = [switches(i), timepoints(end)];
                Gy_t_ts_i = cell(1, length(timepoints));
                y_start = y_to_switches(:, i);
                h_y = fdStep_getH_y(FDstep, y_start);
                [sol_original, sols_disturbed] = solveDisturbed_Gy(datahandle, tspan_new, i, y_start, h_y, options);
                y  = repmat(deval(sol_original,timepoints), [1, dim_y]);
                % Cycle through every initial value and compute the sensitivites
                eval_disturb_y0 = cell(1, dim_y);
                for j=1:dim_y
                   sol_disturb = sols_disturbed{j};
                   eval_disturb_y0{j} = deval(sol_disturb,timepoints);
                end
                difference = reshape((cell2mat(eval_disturb_y0) - y), [], dim_y);
                count = 1 : dim_y : size(difference, 1);
                for j = 1:length(timepoints)
                    Gy_t_ts_i{j} = difference(count(j):j*dim_y, 1:dim_y)./reshape(h_y, 1, []);
                end
                if timepoints(1) == switches(i)
                    % at the switch, the sensitivity is eye. Since we applied our h-disturbance to y, though,
                    % our END solution will not reflect this. So, correct the first time point's value.
                    Gy_t_ts_i{1} = eye(dim_y);
                end
                Gy_t_ts{i} = Gy_t_ts_i;
            end
            Gmatrices_intermediate.Gy = [Gmatrices_intermediate.Gy, Gy_new];

            Updates = generateGmatrices_Updates(datahandle, 1, modelNum, Gp_flag, options);
            Gmatrices_intermediate.Uy = [Gmatrices_intermediate.Uy, Updates.Uy_new];

            % After calculating the intermediate G-matrices the sensitivities can be set together according
            % to the respective formula for y0 and p for every group
            for k = 1 : size(timeGroups, 2)
                if isempty(timeGroups{k})
                    continue
                end

                timepoints = timeGroups{k};
                modelNum = k;
                sensData(k).timepoints = timepoints;
                sensData(k).modelNum = modelNum;
                Gy_t_ts_k = Gy_t_ts{k};

                Gy_intermediate = Gmatrices_intermediate.Gy;
                Uy = Gmatrices_intermediate.Uy;
                Gy_timepoints = cell(1, length(timepoints));
                for j = 1:length(timepoints)
                    Gy = Gy_t_ts_k{j};
                    for i = modelNum : -1 : 2
                        Gy = Gy * Uy{i} * Gy_intermediate{i};
                    end
                    Gy_timepoints{j} = Gy;
                end
                sensData(k).Gy = Gy_timepoints;
            end
            if Gp_flag
                parameters = data.SWP_detection.parameters;
                Gp_new = cell(1, modelNum);
                Gp_t_ts = cell(1, modelNum);
                for i=1:modelNum
                    tspan_new = [switches(i), switches(i+1)];
                    y_start = y_to_switches(:, i);
                    h_p = fdStep_getH_p(FDstep, parameters);
                    [sol_original, sols_disturbed] = solveDisturbed_Gp(datahandle, tspan_new, i, y_start, h_p, options);
                    eval_disturb_p = zeros(dim_y, dim_p);
                    for j=1:dim_p
                        sol_disturb = sols_disturbed{j};
                        eval_disturb_p(:,j) = deval(sol_disturb, switches(i+1));
                    end
                    y = deval(sol_original, switches(i+1));
                    Gp_new{i} = (eval_disturb_p - y)./ reshape(h_p, 1, []);
                end
                for i=1:modelNum
                    timepoints = timeGroups{i};
                    Gp_t_ts_i = cell(1, length(timepoints));
                    tspan_new = [switches(i), timepoints(end)];
                    y_start = y_to_switches(:, i);
                    h_p = fdStep_getH_p(FDstep, parameters);

                    [sol_original, sols_disturbed] = solveDisturbed_Gp(datahandle, tspan_new, i, y_start, h_p, options);
                    % Cycle through every parameter and compute the sensitivites
                    eval_disturb_p = cell(1, dim_p);
                    for j=1:dim_p
                        sol_disturb = sols_disturbed{j};
                        eval_disturb_p{j} = deval(sol_disturb, timepoints);
                    end
                    y  = repmat(deval(sol_original, timepoints), [1, dim_p]);
                    difference = reshape((cell2mat(eval_disturb_p) - y), [], dim_p);
                    count = 1 : dim_y : size(difference, 1);
                    for j = 1:length(timepoints)
                        Gp_t_ts_i{j} = difference(count(j):j*dim_y, 1:dim_p)./reshape(h_p, 1, []);
                    end
                    if timepoints(1) == switches(i)
                        % Gp(t_0, t_0)=0. But since we apply our h-disturbance to the initial values, our solution will not reflect
                        % this. Here, we correct this case.
                        Gp_t_ts_i{1} = zeros(dim_y, dim_p);
                    end
                    Gp_t_ts{i} = Gp_t_ts_i;
                end
                Gmatrices_intermediate.Gp = [Gmatrices_intermediate.Gp, Gp_new];
                Gmatrices_intermediate.Up = [Gmatrices_intermediate.Up, Updates.Up_new];

                for k = 1 : size(timeGroups, 2)
                    if isempty(timeGroups{k})
                        continue
                    end
                    timepoints = timeGroups{k};
                    Gy = Gmatrices_intermediate.Gy;
                    Uy = Gmatrices_intermediate.Uy;
                    Up = Gmatrices_intermediate.Up;
                    Gp_intermediate = Gmatrices_intermediate.Gp;
                    Gy_t_ts_k = Gy_t_ts{k};
                    Gp_t_ts_k = Gp_t_ts{k};
                    Gp_prev = Gp_intermediate{1};
                    for i=2:k
                        Gp_prev = Gy{i} * (Uy{i-1}*Gp_prev+Up{i-1}) + Gp_intermediate{i};
                    end
                    Gp = cell(1, length(timepoints));
                    if k == 1
                        Gp = Gp_t_ts_k;
                    else
                        for i = 1:length(timepoints)
                            Gp{i} = Gy_t_ts_k{i} * (Uy{k} * Gp_prev + Up{k}) + Gp_t_ts_k{i};
                        end
                    end
                    sensData(k).Gp = Gp;
                end
            end
            sensitivitiesOutput = assembleSensitivityOutput(sensData, Gmatrices_intermediate, t_sort_unique, Gy_flag, Gp_flag, Gmatrices_intermediate_flag);
            sensitivities(:) = sensitivitiesOutput(unique_indices);
        else % VDE
            % The unique timepoints are separated into groups according to their model number, that means all time points that are between the same
            % two switching points are in one group. If one group is empty (so no timepoint is given between two switching points), 
            % the group is left empty and will be skipped in the calculations later. 
            switches_temp = switches;
            switches_temp(end) = switches_temp(end) + eps(switches_temp(end));
            amountGroups = length(switches) - 1;
            timeGroups = cell(1, amountGroups);
      
            for i = 1:length(switches)-1
                indices = (t_sort_unique >= switches_temp(i)) & (t_sort_unique < switches_temp(i+1));
                timeGroups{i} = t_sort_unique(indices);
            end

            % sensData is a struct array that is as long as the amount of the time groups and every index belongs to one group
            sensData = generateSensData(amountGroups);

            % The latest timepoint is being extracted to know how many intermediate matrices need to be calculated because they are needed until 
            % the last switch before the latest timepoint. 
            t_max = t_sort_unique(end);
            modelNum = find(t_max < switches_temp, 1) - 1;
            
            % if the method END_full has been chosen before, the data for the sensitivity generation needs to be generated again here.
            generateData(datahandle, sol);

            % solve the VDE on each of the intervals between the switches
            solVDEs_y = cell(1, modelNum);
            for i=1:modelNum
                tspan_new = [switches(i), switches(i+1)];
                solVDEs_y{i} = solveVDE_Gy(datahandle, sol, tspan_new, i, options);
            end

            % G(ts2, ts1) at the end of each model stage
            Gy_new = cell(1, modelNum);
            % One element for each model stage; this has one element per time point, and these in turn have y_dim x
            % y_dim elements. Whew!
            Gy_t_ts = cell(1, modelNum);
            for i=1:modelNum
                Gy_new{i} = reshape(solVDEs_y{i}.y(:,end), dim_y, dim_y);
                timepoints = timeGroups{i};
                Gy_t_ts_i = cell(1, length(timepoints));
                diff_y_y0_sol = deval(solVDEs_y{i}, timepoints);
                for j = 1:length(timepoints)
                    Gy_t_ts_i{j} = reshape(diff_y_y0_sol(:,j), dim_y, []);
                end
                Gy_t_ts{i} = Gy_t_ts_i;
            end
            Gmatrices_intermediate.Gy = [Gmatrices_intermediate.Gy, Gy_new];

            Updates = generateGmatrices_Updates(datahandle, 1, modelNum, Gp_flag, options);
            Gmatrices_intermediate.Uy = [Gmatrices_intermediate.Uy, Updates.Uy_new];

            % After calculating the intermediate G-matrices the sensitivities can be set together according
            % to the respective formula for y0 and p for every group
            for k = 1 : size(timeGroups, 2)
                if isempty(timeGroups{k})
                    continue
                end

                timepoints = timeGroups{k};
                modelNum = k;
                sensData(k).timepoints = timepoints;
                sensData(k).modelNum = modelNum;
                Gy_t_ts_k = Gy_t_ts{k};

                Gy_intermediate = Gmatrices_intermediate.Gy;
                Uy = Gmatrices_intermediate.Uy;
                Gy_timepoints = cell(1, length(timepoints));
                for j = 1:length(timepoints)
                    Gy = Gy_t_ts_k{j};
                    for i = modelNum : -1 : 2
                        Gy = Gy * Uy{i} * Gy_intermediate{i};
                    end
                    Gy_timepoints{j} = Gy;
                end
                sensData(k).Gy = Gy_timepoints;
            end
            if Gp_flag
                solVDEs_p = cell(1, modelNum);
                for i=1:modelNum
                    tspan_new = [switches(i), switches(i+1)];
                    solVDEs_p{i} = solveVDE_Gp(datahandle, sol, tspan_new, i, options);
                end
                Gp_new = cell(1, modelNum);
                Gp_t_ts = cell(1, modelNum);
                for i=1:modelNum
                    Gp_new{i} = reshape(solVDEs_p{i}.y(:,end), dim_y, dim_p);
                    timepoints = timeGroups{i};
                    Gp_t_ts_i = cell(1, length(timepoints));
                    diff_y_p_sol = deval(solVDEs_p{i}, timepoints);
                    for j = 1:length(timepoints)
                        Gp_t_ts_i{j} = reshape(diff_y_p_sol(:,j), dim_y, []);
                    end
                    Gp_t_ts{i} = Gp_t_ts_i;
                end
                Gmatrices_intermediate.Gp = [Gmatrices_intermediate.Gp, Gp_new];
                Gmatrices_intermediate.Up = [Gmatrices_intermediate.Up, Updates.Up_new];

                for k = 1 : size(timeGroups, 2)
                    if isempty(timeGroups{k})
                        continue
                    end
                    timepoints = timeGroups{k};
                    Gy = Gmatrices_intermediate.Gy;
                    Uy = Gmatrices_intermediate.Uy;
                    Up = Gmatrices_intermediate.Up;
                    Gp_intermediate = Gmatrices_intermediate.Gp;
                    Gy_t_ts_k = Gy_t_ts{k};
                    Gp_t_ts_k = Gp_t_ts{k};
                    Gp_prev = Gp_intermediate{1};
                    for i=2:k
                        Gp_prev = Gy{i} * (Uy{i-1}*Gp_prev+Up{i-1}) + Gp_intermediate{i};
                    end
                    Gp = cell(1, length(timepoints));
                    if k == 1
                        Gp = Gp_t_ts_k;
                    else
                        for i = 1:length(timepoints)
                            Gp{i} = Gy_t_ts_k{i} * (Uy{k} * Gp_prev + Up{k}) + Gp_t_ts_k{i};
                        end
                    end
                    sensData(k).Gp = Gp;
                end
            end
            sensitivitiesOutput = assembleSensitivityOutput(sensData, Gmatrices_intermediate, t_sort_unique, Gy_flag, Gp_flag, Gmatrices_intermediate_flag);
            sensitivities(:) = sensitivitiesOutput(unique_indices);
      end
   end
end