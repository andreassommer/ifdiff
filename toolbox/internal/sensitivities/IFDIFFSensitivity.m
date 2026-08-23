classdef IFDIFFSensitivity
    %IFDIFFSENSITIVITY Summary of this class goes here
    %   Detailed explanation goes here

    properties
        datahandle
        solution
        parameters
        initialValues
        tspan
        switches
        switchesY
        switchesLeft
        switchesLeftY
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
            'END_piecewise', 2, ...
            'END_full', 3)
    end

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

    methods
        function this = IFDIFFSensitivity(datahandle, sol, calcGy, calcGp, dirY, dirP, fdStep, method)
            if nargin == 0
                return;
            end

            this.datahandle = datahandle;
            this.solution = sol;
            data = datahandle.getData();
            this.switchingFunctions = data.SWP_detection.switchingFunction;
            this.jumpFunctions = data.SWP_detection.jumpFunction;

            this.initialValues = data.SWP_detection.initialvalues;
            this.parameters = data.SWP_detection.parameters;
            this.dimy = length(this.initialValues);
            this.dimp = length(this.parameters);

            this.tspan = data.SWP_detection.tspan;
            this.switches = sort(sol.switches);

            [isSwitchInSol, switchesIdx] = ismember(this.switches, sol.x);
            if ~all(isSwitchInSol)
                error('IFDIFF:Sensitivity:SwitchNotInSol', ...
                    'Switch at t=%.10g not found in solution time points.', ...
                    this.switches(find(~isSwitchInSol, 1)));
            end
            this.switchesY = sol.y(:, switchesIdx);

            this.switchesLeft = this.switches;
            this.switchesLeftY = this.switchesY;
            % Use left limit of switch if there was a jump.
            this.switchesLeft(sol.jumps) = sol.x(switchesIdx(sol.jumps) - 1);
            this.switchesLeftY(:, sol.jumps) = sol.y(:, switchesIdx(sol.jumps) - 1);

            this.integrator = data.integratorSettings.numericIntegrator;
            this.integratorOptions = data.integratorSettings.options;

            if ~calcGy && ~calcGp
                error('IFDIFF:Sensitivity:NothingToCompute', 'Neither initial value nor parameter sensitivity was requested.')
            end
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

            methodNum = this.METHOD.(method);
            switch methodNum
                case this.METHOD.VDE
                    this.solver = @this.solveVde;
                case this.METHOD.END_piecewise
                    this.solver = @this.solveEnd;
                otherwise
                    id = 'IFDIFF:Sensitivity:UnrecognizedSolver';
                    msg = 'The solver with number %d derived from string ''%s'' does not exist.';
                    error(id, msg, methodNum, method);
            end
        end

        function [sensEnd, sensFun] = solveVde(this, idxModel, tspan, sensStart, nDirY)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);
            df = IFDIFFDerivativeFiniteDifferences(this.datahandle, rhs, this.dimy, this.fdStep);

            rhsVde = @(t, G) vdeRhs(t, G, this.parameters, this.solution, nDirY, df, this.dirP);
            sensStart = sensStart(:);
            sol = this.integrator(rhsVde, tspan, sensStart, this.integratorOptions);

            sensEnd = sol.y(:, end);
            sensFun = @(t) deval(sol, t);
        end

        function [sensEnd, sensFun] = solveEnd(this, idxModel, tspan, sensStart, nDirY)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);

            if idxModel == 1
                y0 = this.initialValues;
            else
                y0 = this.switchesY(:, idxModel - 1);
            end

            nDir = size(sensStart, 2);
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

        function [sens, fPlus] = applySensitivitySwitchUpdate(this, sens, idxModel, fMinus)
            t = this.switches(idxModel);
            y = this.switchesLeftY(:, idxModel);
            yPlus = this.switchesY(:, idxModel);

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

        function [sens, sensFun] = eval(this, timepoints)
            % Ensure timepoints are strictly increasing.
            [t, ~, idxTimepointsUndoSort] = unique(timepoints);

            if t(1) < this.tspan(1) || t(end) > this.tspan(end)
                error('IFDIFF:Sensitivity:TimepointOutOfBounds', ...
                    ['Requested sensitivity evaluation timepoint is not contained within,', ...
                    'the solution interval of the IVP.']);
            end

            % TODO: May cache solution from previous runs for the same parameters.
            % For now, always start solving from the first model.
            idxModelStart = 1;
            % Determine the model of the last evaluation timepoint.
            idxModelEnd = find(t(end) <= [this.switches, this.tspan(end)], 1);

            tModelStart = this.tspan(1);
            sensInitialValue = [this.dirY, zeros(this.dimy, size(this.dirP, 2))];
            nDirY = size(this.dirY, 2);

            % Integrate each submodel until switch and apply update at the end.
            nModels = idxModelEnd - idxModelStart + 1; % Guaranteed to be greater than zero.
            sensFun = cell(1, nModels);
            for idxModel=idxModelStart:idxModelEnd-1
                tModelEnd = this.switchesLeft(idxModel);
                [sensEnd, sensFun{idxModel - idxModelStart + 1}] = this.solver( ...
                    idxModel, [tModelStart, tModelEnd], sensInitialValue, nDirY);

                % Prepare next model.
                tModelStart = this.switches(idxModel);
                % Update initial value for next VDE at switch using update formula.
                sensInitialValue = reshape(sensEnd, this.dimy, []);
                % Setup fMinus beforehand for the first update. Next updates can just use fPlus from the preceding update.
                if idxModel == idxModelStart
                    fMinus = getRhsFromModelNum(this.datahandle, idxModelStart);
                end
                [sensInitialValue, fMinus] = this.applySensitivitySwitchUpdate(sensInitialValue, idxModel, fMinus);
            end
            % No more switches left, so solve until the end.
            tModelEnd = t(end);
            [~, sensFun{idxModelEnd - idxModelStart + 1}] = this.solver( ...
                idxModelEnd, [tModelStart, tModelEnd], sensInitialValue, nDirY);

            % Return sensitivity at requested timepoints
            sens = evalPiecewiseFunc(t, sensFun, numel(sensInitialValue), this.switches);
            sens = reshape(sens, this.dimy, size(sensInitialValue, 2), []);
            sens = sens(:, :, idxTimepointsUndoSort);
        end
    end
end
