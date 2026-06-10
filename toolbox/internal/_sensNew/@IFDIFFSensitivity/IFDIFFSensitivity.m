classdef IFDIFFSensitivity
    %IFDIFFSENSITIVITY Summary of this class goes here
    %   Detailed explanation goes here

    properties
        datahandle
        solution
        parameters
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
    end

    methods
        function this = IFDIFFSensitivity(datahandle, sol, dirY, dirP)
            this.datahandle = datahandle;
            this.solution = sol;
            data = datahandle.getData();
            this.switchingFunctions = data.SWP_detection.switchingFunction;
            this.jumpFunctions = data.SWP_detection.jumpFunction;

            this.parameters = data.SWP_detection.parameters;
            this.dimy = length(data.SWP_detection.initialvalues);
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

            if isempty(dirY)
                dirY = eye(this.dimy);
            end
            if isempty(dirP)
                dirP = eye(this.dimp);
            end
            this.dirY = dirY;
            this.dirP = dirP;
        end

        function sol = solveVde(this, idxModel, tspan, initialValues, nDirY)
            rhs = getRhsFromModelNum(this.datahandle, idxModel);
            rhs = @(t, y, p) rhs(this.datahandle, t, y, p);

            h = 1e-6; % TODO: temporarily hard-coded
            fDyPartial = @(t, y, p, v) finiteDifference(@(x) rhs(t, x, p), y, h, v);
            nDirP = size(initialValues, 2) - nDirY;
            if nDirP > 0
                fDpPartial = @(t, y, p) finiteDifference(@(x) rhs(t, y, x), p, h, this.dirP);
            else
                fDpPartial = [];
            end

            rhsVde = @(t, G) vdeRhs(t, G, this.parameters, this.solution, nDirY, fDyPartial, fDpPartial);
            initialValues = initialValues(:);
            sol = this.integrator(rhsVde, tspan, initialValues, this.integratorOptions);
        end

        function [sens, fPlus] = applySensitivitySwitchUpdate(this, sens, idxModel, fMinus)
            tMinus = this.switchesLeft(idxModel);
            tPlus = this.switches(idxModel);
            yMinus = this.switchesLeftY(:, idxModel);
            yPlus = this.switchesY(:, idxModel);

            % TODO: Fix ugly workaround after datahandle refactor.
            % If the submodel is not exported as a separate function and instead relies on the datahandle,
            % then we have to evaluate fMinus here, so that the signature is set correctly for fPlus.
            if makeConfig().removeCtrlifForSensComputation
                fMinusEval = fMinus(this.datahandle, tMinus, yMinus, this.parameters);
                fMinus = @(~, ~, ~, ~) fMinusEval;
            end
            fPlus = getRhsFromModelNum(this.datahandle, idxModel + 1);

            % Setup derivatives.
            sigma = this.switchingFunctions{idxModel};
            jump = this.jumpFunctions{idxModel};
            h = 1e-6; % TODO: temporarily hard-coded
            sigmat = @(t, y, p, v) finiteDifference(@(x) sigma([], x, y, p), t, h, v);
            sigmay = @(t, y, p, v) finiteDifference(@(x) sigma([], t, x, p), y, h, v);
            sigmap = @(t, y, p, v) finiteDifference(@(x) sigma([], t, y, x), p, h, v);
            if isempty(jump)
                jumpt = [];
                jumpy = [];
                jumpp = [];
            else
                jumpt = @(t, y, p, v) finiteDifference(@(x) jump([], x, y, p), t, h, v);
                jumpy = @(t, y, p, v) finiteDifference(@(x) jump([], t, x, p), y, h, v);
                jumpp = @(t, y, p, v) finiteDifference(@(x) jump([], t, y, x), p, h, v);
            end

            sens = computeSensitivitySwitchUpdate( ...
                sens, this.dirP, ...
                tMinus, tPlus, yMinus, yPlus, this.parameters, ...
                @(t, y, p) fMinus(this.datahandle, t, y, p), @(t, y, p) fPlus(this.datahandle, t, y, p), ...
                sigmat, sigmay, sigmap, ...
                jumpt, jumpy, jumpp);
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
            sensUnique = evalPiecewiseFunc(t, piecewiseFunc, numel(sensInitialValue), this.switches);
            sensUnique = reshape(sensUnique, this.dimy, size(sensInitialValue, 2), []);
            sens = sensUnique(:, :, idxTimepointsUndoSort);
        end
    end
end
