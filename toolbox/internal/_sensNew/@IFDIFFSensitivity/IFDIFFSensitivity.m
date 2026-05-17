classdef IFDIFFSensitivity
    %IFDIFFSENSITIVITY Summary of this class goes here
    %   Detailed explanation goes here

    properties
        datahandle
        solution
        Uy
        Up
        UyAccumulated
        UpAccumulated
        GySol = {}
        GpSol
        parameters
        tspan
        switches
        switchesY
        switchesLeft
        switchesLeftY
        dimy
        dimp
        fdStep
        modelBoundaries
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
            this.modelBoundaries = [this.tspan(1), this.switches, this.tspan(end)];

            [isSwitchInSol, switchesIdx] = ismember(this.switches, sol.x);
            if ~all(isSwitchInSol)
                error('IFDIFF:Sensitivity:SwitchNotInSol', ...
                    'Switch at t=%.10g not found in solution time points.', ...
                    this.switches(find(~isSwitchInSol, 1)));
            end
            this.switchesY = sol.y(:, switchesIdx);

            this.switchesLeft = this.switches;
            this.switchesLeftY = this.switchesY;
            this.switchesLeft(sol.jumps) = sol.x(switchesIdx(sol.jumps) - 1);
            this.switchesLeftY(:, sol.jumps) = sol.y(:, switchesIdx(sol.jumps) - 1);

            this.fdStep = generateFDstep(this.dimy, this.dimp);

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

        function this = eval(this, timepoints)
            [t, ~, idxTimepointsUndoSort] = unique(timepoints);

            if t(1) < this.tspan(1) || t(end) > this.tspan(end)
                error('IFDIFF:Sensitivity:TimepointOutOfBounds', ...
                    ['Requested sensitivity evaluation timepoint is not contained within,', ...
                    'the solution interval of the IVP.']);
            end

            idxModelStart = 1;
            % Find the switch, that would come after the last evaluation timepoint
            idxModelEnd = find(t(end) <= this.modelBoundaries, 1) - 1;

            tstart = this.tspan(1);
            sens = [this.dirY, zeros(this.dimy, size(this.dirP, 2))];
            nDirY = size(this.dirY, 2);
            if idxModelEnd > idxModelStart
                fMinus = getRhsFromModelNum(this.datahandle, idxModelStart);
            end
            for idxModel=idxModelStart:idxModelEnd-1
                tend = this.switchesLeft(idxModel);
                sol = this.solveVde(idxModel, [tstart, tend], sens, nDirY, this.dirP);
                tstart = this.switches(idxModel);
                this.GySol{idxModel} = sol;

                sens = reshape(sol.y(:, end), this.dimy, []);

                % Update (not on last iteration)
                yMinus = this.switchesLeftY(:, idxModel);
                yPlus = this.switchesY(:, idxModel);
                fPlus = getRhsFromModelNum(this.datahandle, idxModel + 1);
                sigma = this.switchingFunctions{idxModel};
                jump = this.jumpFunctions{idxModel};
                h = 1e-6;
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
                sens = applySensitivitySwitchUpdate( ...
                    sens, this.dirP, size(this.dirY, 2), ...
                    tend, tstart, yMinus, yPlus, this.parameters, ...
                    @(t,y,p) fMinus(this.datahandle,t,y,p), @(t,y,p) fPlus(this.datahandle,t,y,p), ...
                    sigmat, sigmay, sigmap, ...
                    jumpt, jumpy, jumpp);
                fMinus = fPlus;
            end
            idxModel = idxModel + 1;
            tend = t(end);
            sol = this.solveVde(idxModel, [tstart, tend], sens, nDirY, this.dirP);
            this.GySol{idxModel} = sol;
        end

        sol = solveVde(this, idxModel, tspan, initialValues, nDirY, initialDirP)
    end
end
