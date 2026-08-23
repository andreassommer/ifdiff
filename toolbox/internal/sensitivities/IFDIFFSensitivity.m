classdef IFDIFFSensitivity < handle
    %IFDIFFSensitivity - Compute switched ODE sensitivity
    %
    %    Description
    %      Compute (directional) sensitivity w.r.t. initial values or parameters for switched ODEs.
    %      The algorithm uses Variational Differential Equations (VDE) or external numerical differentiation (END)
    %      to compute sensitivity for the piecewise smooth segments, which are then combined at switching points using update formulas.
    %
    %    Properties
    %      datahandle - Contains information about the preprocessed switched ODE
    %        datahandle struct
    %      solution - Solution for which the sensitivity will be computed
    %        solution struct
    %      calcGy/calcGp - Flag to enable computation of sensitivity w.r.t. initial values or parameters
    %        boolean scalar
    %      dirY - Directions in which to compute the sensitivity w.r.t initial values
    %        n-by-m numeric matrix, where n is the state dimension and m is the number of directions.
    %        Set to n-by-n identity matrix if left empty.
    %      dirP - Directions in which to compute the sensitivity w.r.t. parameters
    %        k-by-l numeric matrix, where k is the parameter dimension and l is the number of directions.
    %        Set to k-by-k identity matrix if left empty.
    %      fdStep - Contains step size information for the finite difference method used in the algorithm
    %        struct obtained from the generateFDstep function
    %      methodStr - Determines the method used to compute piecewise smooth sensitivity segments
    %        character array, either 'VDE' or 'END_piecewise'
    %
    %    Methods
    %      eval - Evaluate sensitivity at the given timepoints
    %
    %    See also GENERATESENSITIVITYFUNCTION



    properties
        datahandle
        solution
        parameters
        initialValues
        tspan
        switches
        ySwitch
        ySwitchLeft
        dimy
        dimp
        integrator
        integratorOptions
        dirY
        dirP
        switchingFunctions
        jumpFunctions
        fdStep
        method
    end

    properties (Access=private)
        solver
    end

    properties (Constant)
        METHOD = struct( ...
            'VDE', 1, ...
            'END_piecewise', 2)
    end

    methods
        function this = IFDIFFSensitivity(datahandle, solution, calcGy, calcGp, dirY, dirP, fdStep, methodStr)
            if nargin == 0
                return;
            end

            % Check solver validity.
            if ~calcGy && ~calcGp
                throw(this.nothingToComputeException);
            end

            methodNum = this.METHOD.(methodStr);
            switch methodNum
                case this.METHOD.VDE
                    this.solver = @this.solveVde;
                case this.METHOD.END_piecewise
                    this.solver = @this.solveEnd;
                otherwise
                    throw(this.unrecognizedSolverException(methodNum, methodStr))
            end

            % Extract relevant fields from datahandle.
            this.datahandle = datahandle;
            this.solution = solution;
            data = datahandle.getData();
            this.switchingFunctions = data.SWP_detection.switchingFunction;
            this.jumpFunctions = data.SWP_detection.jumpFunction;

            this.initialValues = data.SWP_detection.initialvalues;
            this.parameters = data.SWP_detection.parameters;
            this.dimy = length(this.initialValues);
            this.dimp = length(this.parameters);

            this.tspan = data.SWP_detection.tspan;
            this.switches = sort(solution.switches);

            % Extract state jumps from solution
            [isSwitchInSol, switchesIdx] = ismember(this.switches, solution.x);
            if ~all(isSwitchInSol)
                throw(this.switchNotFoundInSolutionException(this.switches(~isSwitchInSol)));
            end
            this.ySwitch = solution.y(:, switchesIdx);
            this.ySwitchLeft = this.ySwitch;

            % Use left limit of switch if there was a jump.
            this.ySwitchLeft(:, solution.jumps) = solution.y(:, switchesIdx(solution.jumps) - 1);

            this.integrator = data.integratorSettings.numericIntegrator;
            this.integratorOptions = data.integratorSettings.options;

            % Setup directions.
            if ~calcGy
                dirY = [];
            elseif isempty(dirY)
                dirY = eye(this.dimy);
            end
            if ~calcGp
                dirP = [];
            elseif isempty(dirP)
                dirP = eye(this.dimp);
            end
            this.dirY = dirY;
            this.dirP = dirP;

            this.fdStep = fdStep;
        end

        %% Main algorithm
        function [sens, sensFun] = eval(this, timepoints)
            % Ensure timepoints are strictly increasing.
            [t, ~, idxSort] = unique(timepoints);

            if t(1) < this.tspan(1) || t(end) > this.tspan(end)
                throw(this.timepointOutOfBoundsException(t(1), t(end), this.tspan));
            end

            % Determine the model of the last evaluation timepoint.
            idxModelEnd = find(t(end) <= [this.switches, this.tspan(end)], 1);

            tModelStart = this.tspan(1);
            sensInitialValue = [this.dirY, zeros(this.dimy, size(this.dirP, 2))];

            sensFun = cell(1, idxModelEnd);
            for idxModel=1:idxModelEnd-1
                tModelEnd = this.switches(idxModel);
                [sensEnd, sensFun{idxModel}] = this.solver(idxModel, [tModelStart, tModelEnd], sensInitialValue);

                % Prepare next model.
                tModelStart = tModelEnd;
                % Update initial value for next VDE at switch using update formula.
                sensInitialValue = reshape(sensEnd, this.dimy, []);
                % Setup fMinus beforehand for the first update. Next updates can just use fPlus from the preceding update.
                if idxModel == 1
                    fMinus = getRhsFromModelNum(this.datahandle, 1);
                end
                [sensInitialValue, fMinus] = this.applySensitivitySwitchUpdate(sensInitialValue, idxModel, fMinus);
            end
            % No more switches left, so solve until the end.
            tModelEnd = t(end);
            [~, sensFun{end}] = this.solver(idxModelEnd, [tModelStart, tModelEnd], sensInitialValue);

            % Return sensitivity at requested timepoints.
            sens = evalPiecewiseFunc(t, sensFun, numel(sensInitialValue), this.switches);
            sens = reshape(sens, this.dimy, size(sensInitialValue, 2), []);
            sens = sens(:, :, idxSort);
        end

        function [sens, fPlus] = applySensitivitySwitchUpdate(this, sens, idxModel, fMinus)
            t = this.switches(idxModel);
            y = this.ySwitchLeft(:, idxModel);
            yPlus = this.ySwitch(:, idxModel);

            dyLeft = fMinus(this.datahandle, t, y, this.parameters);
            fPlus = getRhsFromModelNum(this.datahandle, idxModel + 1);
            dyRight = fPlus(this.datahandle, t, yPlus, this.parameters);

            % Setup derivatives.
            sigma = this.switchingFunctions{idxModel};
            jump = this.jumpFunctions{idxModel};

            dSigma = IFDIFFDerivativeFiniteDifferences([], sigma, 1, this.fdStep);
            if ~isempty(jump)
                dJump = IFDIFFDerivativeFiniteDifferences([], jump, this.dimy, this.fdStep);
            else
                dJump = [];
            end

            sens = computeSensitivitySwitchUpdate(sens, this.dirP, t, y, this.parameters, dyLeft, dyRight, dSigma, dJump);
        end

        %% Solver Methods
        function [sensEnd, sensFun] = solveVde(this, idxModel, tspan, sensStart)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);
            df = IFDIFFDerivativeFiniteDifferences(this.datahandle, rhs, this.dimy, this.fdStep);

            rhsVde = @(t, G) vdeRhs(t, G, this.parameters, this.solution, df, this.dirP);
            sensStart = sensStart(:);
            sol = this.integrator(rhsVde, tspan, sensStart, this.integratorOptions);

            sensEnd = sol.y(:, end);
            sensFun = @(t) deval(sol, t);
        end

        function [sensEnd, sensFun] = solveEnd(this, idxModel, tspan, sensStart)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);

            if idxModel == 1
                y0 = this.initialValues;
            else
                y0 = this.ySwitch(:, idxModel - 1);
            end

            nDir = size(sensStart, 2);
            nDirY = nDir - size(this.dirP, 2);

            solDisturbY = cell(1, nDir);
            solDisturbP = cell(1, nDir);
            % Solve with disturbed initial values.
            fd = IFDIFFDerivativeFiniteDifferences([], [], [], this.fdStep);
            hy = fd.hy(y0);
            [yh, hy, idxNonzeroY] = fd.scaleDirections(y0, sensStart, hy);
            % Pad to full length to avoid indexing issues.
            hyFull = zeros(1, nDir);
            hyFull(idxNonzeroY) = hy;
            for i=idxNonzeroY
                solDisturbY{i} = this.integrator( ...
                    @(t, y) rhs(this.datahandle, t, y, this.parameters), tspan, yh(:, i), this.integratorOptions);
            end
            % Solve with disturbed parameters.
            hpFull = [];
            if nDirY < nDir
                hp = fd.hp(this.parameters);
                [ph, hp, idxNonzeroP] = fd.scaleDirections(this.parameters, this.dirP, hp);
                % Pad to full length to avoid indexing issues.
                hpFull = zeros(1, nDir);
                hpFull(nDirY + idxNonzeroP) = hp;
                for i=idxNonzeroP
                    solDisturbP{nDirY + i} = this.integrator( ...
                        @(t, y) rhs(this.datahandle, t, y, ph(:, i)), tspan, y0, this.integratorOptions);
                end
            end

            sensEnd = zeros(this.dimy, nDir);
            % Re-solve the undisturbed RHS here to be more consistent with the disturbed solution.
            sol = this.integrator(@(t, y) rhs(this.datahandle, t, y, this.parameters), tspan, y0, this.integratorOptions);
            yEnd = deval(sol, tspan(end));
            for i=1:nDir
                solY = solDisturbY{i};
                solP = solDisturbP{i};
                if ~isempty(solY)
                    sensEnd(:, i) = (solY.y(:, end) - yEnd) ./ hyFull(i);
                end
                if ~isempty(solP)
                    sensEnd(:, i) = sensEnd(:, i) + (solP.y(:, end) - yEnd) ./ hpFull(i);
                end
            end
            sensFun = this.getFiniteDifferenceSolFun(sol, this.dimy, solDisturbY, solDisturbP, hyFull, hpFull);
        end
    end

    %% Internal Helpers
    methods (Static)
        function f = getFiniteDifferenceSolFun(sol, dim, solDisturbY, solDisturbP, hy, hp)
            f = @computeSens;
            nDir = length(solDisturbY);

            function sens = computeSens(t)
                nt = length(t);
                sens = zeros(dim, nDir, nt);

                solT = [];
                for i=1:nDir
                    solY = solDisturbY{i};
                    solP = solDisturbP{i};
                    % Make sure we evaluate the solution only once if needed.
                    if isempty(solT) && (~isempty(solY) | ~isempty(solT))
                        solT = deval(sol, t);
                    end

                    if ~isempty(solY)
                        sens(:, i, :) = (deval(solY, t) - solT) ./ hy(i);
                    end
                    if ~isempty(solP)
                        sens(:, i, :) = sens(:, i, :) + reshape((deval(solP, t) - solT) ./ hp(i), dim, 1, nt);
                    end
                end
                sens = reshape(sens, [], nt);
            end
        end
    end

    %% Exceptions
    methods (Static)
        function e = nothingToComputeException()
            id = 'IFDIFF:Sensitivity:NothingToCompute';
            msg = 'Neither initial value nor parameter sensitivity was requested.';
            e = MException(id, msg);
        end

        function e = unrecognizedSolverException(methodNum, methodStr)
            id = 'IFDIFF:Sensitivity:UnrecognizedSolver';
            msg = 'The solver with number %d derived from string ''%s'' does not exist.';
            e = MException(id, msg, methodNum, methodStr);
        end

        function e = switchNotFoundInSolutionException(switches)
            id = 'IFDIFF:Sensitivity:SwitchNotInSolution';
            msg = 'Switches at t=[%s] not found in solution time points.';
            switchesStr = arrayStrJoin(switches, ', ', '%.16g');
            e = MException(id, msg, switchesStr);
        end

        function e = timepointOutOfBoundsException(tStart, tEnd, tSpan)
            id = 'IFDIFF:Sensitivity:TimepointOutOfBounds';
            msg = 'Requested sensitivity evaluation timepoints [%s] are not contained in solution interval [%s].';

            tBad = [];
            if tStart < tSpan(1)
                tBad(end+1) = tStart;
            end
            if tEnd > tSpan(2)
                tBad(end+1) = tEnd;
            end
            tBadStr = arrayStrJoin(tBad, ', ', '%.16g');
            tSpanStr = arrayStrJoin(tSpan, ', ', '%.16g');

            e = MException(id, msg, tBadStr, tSpanStr);
        end
    end
end
