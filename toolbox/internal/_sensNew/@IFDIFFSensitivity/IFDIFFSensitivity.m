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

    properties (Constant)
        METHOD = struct( ...
            'VDE', 1, ...
            'END_piecewise', 2, ...
            'END_full', 3)
    end

    methods (Static)
        function f = getFiniteDifferenceSolFun(sol, solDisturbY, solDisturbP, hy, hp, dim)
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
                        sens(:, i, :) = (deval(solY) - solT) ./ hy;
                    end
                    if ~isempty(solP)
                        sens(:, i, :) = sens(:, i, :) + (deval(solP) - solT) ./ hp;
                    end
                end
            end
        end
    end

    methods
        function this = IFDIFFSensitivity(datahandle, sol, calcGy, calcGp, dirY, dirP, fdStep, method)
            if nargin < 8
                method = 'VDE';
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

            this.method = this.METHOD.(method);
        end

        function sol = solveVde(this, idxModel, tspan, initialValues, nDirY)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);
            df = IFDIFFDerivativeFiniteDifferences(this.datahandle, rhs, this.dimy, this.fdStep);

            rhsVde = @(t, G) vdeRhs(t, G, this.parameters, this.solution, nDirY, df, this.dirP);
            initialValues = initialValues(:);
            sol = this.integrator(rhsVde, tspan, initialValues, this.integratorOptions);
        end

        function sensFun = solveEnd(this, idxModel, tspan, sensitivity, nDirY)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);

            if idxModel == 1
                y0 = this.initialValues;
            else
                y0 = this.switchesY(:, idxModel - 1);
            end


            nDir = size(sensitivity, 2);
            solDisturbY = cell(1, nDir);
            solDisturbP = cell(1, nDir);
            % Solve with disturbed initial values.
            fd = IFDIFFDerivativeFiniteDifferences([], [], [], this.fdStep);
            hy = fd.hy(y0);
            [yh, hy, idxNonzeroY] = fd.scaleDirections(y0, sensitivity, hy);
            for i=idxNonzeroY
                solDisturbY{i} = this.integrator( ...
                    @(t, y) rhs(this.datahandle, t, y, this.parameters), tspan, yh(:, i), this.integratorOptions);
            end
            % Solve with disturbed parameters.
            if nDirY < nDir
                hp = fd.hp(this.parameters);
                [ph, hp, idxNonzeroP] = fd.scaleDirections(this.parameters, this.dirP, hp);
            end
            for i=1:idxNonzeroP
                solDisturbP{i} = this.integrator( ...
                    @(t, y) rhs(this.datahandle, t, y, ph(:, i)), tspan, y0, this.integratorOptions);
            end

            sensFun = this.getFiniteDifferenceSolFun(this.solution, solDisturbY, solDisturbP, hy, hp, this.dimy);
        end

        function [sens, fPlus] = applySensitivitySwitchUpdate(this, sens, idxModel, fMinus)
            tMinus = this.switchesLeft(idxModel);
            tPlus = this.switches(idxModel);
            yMinus = this.switchesLeftY(:, idxModel);
            yPlus = this.switchesY(:, idxModel);

            % TODO: Fix ugly workaround after datahandle refactor.
            % If the submodel is not exported as a separate function and instead relies on the datahandle,
            % then we have to evaluate fMinus here, so that the signature is set correctly for fPlus.
            if ~makeConfig().removeCtrlifForSensComputation
                fMinusEval = fMinus(this.datahandle, tMinus, yMinus, this.parameters);
                fMinus = @(~, ~, ~, ~) fMinusEval;
            end
            fPlus = getRhsFromModelNum(this.datahandle, idxModel + 1);

            % Setup derivatives.
            sigma = this.switchingFunctions{idxModel};
            jump = this.jumpFunctions{idxModel};

            dsigma = IFDIFFDerivativeFiniteDifferences([], sigma, 1, this.fdStep);
            if ~isempty(jump)
                djump = IFDIFFDerivativeFiniteDifferences([], jump, this.dimy, this.fdStep);
            else
                djump = [];
            end

            sens = computeSensitivitySwitchUpdate( ...
                sens, this.dirP, ...
                tMinus, tPlus, yMinus, yPlus, this.parameters, ...
                @(t, y, p) fMinus(this.datahandle, t, y, p), @(t, y, p) fPlus(this.datahandle, t, y, p), ...
                dsigma, djump);
        end

        function [sens, sensSol] = eval(this, timepoints)
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
            for idxModel=idxModelStart:idxModelEnd-1
                tModelEnd = this.switchesLeft(idxModel);
                sensSol(idxModel) = this.solveVde(idxModel, [tModelStart, tModelEnd], sensInitialValue, nDirY); %#ok<AGROW>
                tModelStart = this.switches(idxModel);
                % Update initial value for next VDE at switch.
                sensInitialValue = reshape(sensSol(idxModel).y(:, end), this.dimy, []);
                if idxModel == idxModelStart
                    fMinus = getRhsFromModelNum(this.datahandle, idxModelStart);
                end
                [sensInitialValue, fMinus] = this.applySensitivitySwitchUpdate(sensInitialValue, idxModel, fMinus);
            end
            % No more switches left, so solve until the end.
            tModelEnd = t(end);
            sensSol(idxModelEnd) = this.solveVde(idxModelEnd, [tModelStart, tModelEnd], sensInitialValue, nDirY);

            % Return sensitivity at requested timepoints
            piecewiseFunc = arrayfun(@(sol) @(t) deval(sol, t), sensSol, 'UniformOutput', false);
            sens = evalPiecewiseFunc(t, piecewiseFunc, numel(sensInitialValue), this.switches);
            sens = reshape(sens, this.dimy, size(sensInitialValue, 2), []);
            sens = sens(:, :, idxTimepointsUndoSort);
        end
    end
end
