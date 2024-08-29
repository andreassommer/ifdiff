% Solve jumpSensitivityRHS with IFDIFF and print out results of
% 1. the analytic solution
% 2. IFDIFF with standard tolerances and FD step, plus relative error
% 3. IFDIFF with strict tolerances and LONGER FD step, plus relative error
% Note: The analytic solution is computed with the assumption that h_+(t_s) = 0 for switching points t_s.
% This is because having to set h_+ to a value slightly above zero is a burden imposed by IFDIFF, so it
% should also factor into the error

initPaths();

% INITIAL DATA
g     = 9.807;
gamma = 0.9;
p = [g gamma];
t0 = 0;
tEnd = 20.39359; % zeno begins (analytically) at 20.3935964107270316 for these particular data
v0 = 10;
h0 = eps(1)*(1/g) * v0^2;
x0 = [h0; v0];


% CONFIGURATION
% How many switching points to report in the output table
numPointsToReport = 6;
% How many switching points should be between the points reported in the output table
pointStep         = 20;

% Precision settings
solverStandard     = @ode45;
optionsStandard    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
FDstepStandard     = generateFDstep(size(x0,1), length(p));

solverStrict       = @ode45;
optionsStrict      = odeset('AbsTol', 1e-12, 'RelTol', 1e-10);
% pretty wild - the sensitivities are much more precise with larger FDstep.
FDstepStrict       = generateFDstep(size(x0,1), length(p), 'ht', 1e-4, 'hy', 1e-4, 'hp', 1e-4);

% Controlling the table output at the end
% Format string for solution/G values. Using string here to avoid braces all over the place in the table later
valueFormatString = '% 10.6f';
% Format string for relative error
errorFormatString = '% .4e';
printValue = @(x) sprintf(valueFormatString, x);
printError = @(x) sprintf(errorFormatString, x);
plotResults = true;


% MAIN
expectedSwitches     = [t0 bounceballSwitches(numPointsToReport * pointStep, v0, g, gamma) tEnd];

% 1. Compute column names and analytic values for each of the points. For each point t_i, we report
% t_i, v+(t_i), Gy-(t_i, t0), Gp-(t_i, t0), Gy+(t_i, t0), Gp+(t_i, t0)
% For the sensitivities, we leave out the analytic value (it's 2x2) and only write the relative error
% across all entries.
analyticTic = tic;
valueNames    = cell(6 * numPointsToReport, 1);
exact    = cell(6 * numPointsToReport, 1);
Analytic = cell(6 * numPointsToReport, 1);
GyPlus = eye(size(x0, 1));
GpPlus = zeros(size(x0, 1), size(p, 1));
for k=1:numPointsToReport
    i = k * pointStep;
    w = (k-1) * 6;

    i_str  = num2str(i);
    valueNames{w + 1} = ['t_' i_str];
    valueNames{w + 2} = ['v(t_' i_str ')'];
    valueNames{w + 3} = ['G_{x,-}(t_' i_str ', t_0)'];
    valueNames{w + 4} = ['G_{p,-}(t_' i_str ', t_0)'];
    valueNames{w + 5} = ['G_{x,+}(t_' i_str ', t_0)'];
    valueNames{w + 6} = ['G_{p,+}(t_' i_str ', t_0)'];
    for s=1:pointStep
        j = i - pointStep + s;
        t1 = expectedSwitches(j);
        t2 = expectedSwitches(j + 1);
        x2Minus = -gamma^(j-1)*v0;
        [Gy_t2_t1, Gp_t2_t1, Uy_t2, Up_t2] = bounceballSensitivities(g, gamma, t1, t2, x2Minus, true);
        GyMinus = Gy_t2_t1 * GyPlus;
        GpMinus = Gy_t2_t1 * GpPlus + Gp_t2_t1;
        GyPlus = Uy_t2 * GyMinus;
        GpPlus = Uy_t2 * GpMinus + Up_t2;
    end
    exact{w + 1} = expectedSwitches(i+1);
    exact{w + 2} = gamma^i*v0;
    exact{w + 3} = GyMinus;
    exact{w + 4} = GpMinus;
    exact{w + 5} = GyPlus;
    exact{w + 6} = GpPlus;
    Analytic{w + 1} = printValue(exact{w + 1});
    Analytic{w + 2} = printValue(exact{w + 2});
    Analytic{w + 3} = '   <2x2>  ';
    Analytic{w + 4} = '   <2x2>  ';
    Analytic{w + 5} = '   <2x2>  ';
    Analytic{w + 6} = '   <2x2>  ';
end
fprintf('time taken for analytic solutions: %f\n', toc(analyticTic));

standardTic = tic;
% Standard solution and sensitivities
datahandle  = prepareDatahandleForIntegration('bounceballRHS', ...
    'solver', func2str(solverStandard), ...
    'options', optionsStandard);
solStandard = solveODE(datahandle, [t0 tEnd], x0, p);

switchesToReport     = solStandard.switches(pointStep:pointStep:(numPointsToReport*pointStep));
switchesLeft         = switchesToReport - eps(switchesToReport - eps(switchesToReport));
switchesLeftAndRight = reshape([switchesLeft; switchesToReport], 1, []);

sensPoints       = [t0 switchesLeftAndRight tEnd];
sensFunStandard  = generateSensitivityFunction(datahandle, solStandard, FDstepStandard, 'method', 'VDE', ...
    'CalcGy', true, 'CalcGp', true);
sensStandard     = sensFunStandard(sensPoints);
GyStandard       = {sensStandard.Gy};
GpStandard       = {sensStandard.Gp};

ifdiffStandard = cell(6 * numPointsToReport, 1);
errorStandard  = zeros(6 * numPointsToReport, 1);
for k=1:numPointsToReport
    i      = k * pointStep;
    w = (k-1) * 6;

    t_i_standard = solStandard.switches(i);
    v_i_standard = deval(solStandard, t_i_standard, 2);
    ifdiffStandard{w + 1} = t_i_standard;
    ifdiffStandard{w + 2} = v_i_standard;
    ifdiffStandard{w + 3} = GyStandard{2*k};
    ifdiffStandard{w + 4} = GpStandard{2*k};
    ifdiffStandard{w + 5} = GyStandard{2*k+1};
    ifdiffStandard{w + 6} = GpStandard{2*k+1};
end
fprintf('time taken for standard solution: %f\n', toc(standardTic));

% Strict solution and sensitivities
strictTic = tic;
% Strict solution and sensitivities
datahandle  = prepareDatahandleForIntegration('bounceballRHS', ...
    'solver', func2str(solverStrict), ...
    'options', optionsStrict);
solStrict = solveODE(datahandle, [t0 tEnd], x0, p);

switchesToReport     = solStrict.switches(pointStep:pointStep:(numPointsToReport*pointStep));
switchesLeft         = switchesToReport - eps(switchesToReport - eps(switchesToReport));
switchesLeftAndRight = reshape([switchesLeft; switchesToReport], 1, []);

sensPoints       = [t0 switchesLeftAndRight tEnd];
sensFunStrict  = generateSensitivityFunction(datahandle, solStrict, FDstepStrict, 'method', 'VDE', ...
    'CalcGy', true, 'CalcGp', true);
sensStrict     = sensFunStrict(sensPoints);
GyStrict       = {sensStrict.Gy};
GpStrict       = {sensStrict.Gp};

ifdiffStrict = cell(6 * numPointsToReport, 1);
errorStrict  = zeros(6 * numPointsToReport, 1);
for k=1:numPointsToReport
    i      = k * pointStep;
    w = (k-1) * 6;

    t_i_strict = solStrict.switches(i);
    v_i_strict = deval(solStrict, t_i_strict, 2);
    ifdiffStrict{w + 1} = t_i_strict;
    ifdiffStrict{w + 2} = v_i_strict;
    ifdiffStrict{w + 3} = GyStrict{2*k};
    ifdiffStrict{w + 4} = GpStrict{2*k};
    ifdiffStrict{w + 5} = GyStrict{2*k+1};
    ifdiffStrict{w + 6} = GpStrict{2*k+1};
end
fprintf('time taken for strict solution: %f\n', toc(strictTic));


% Relative errors
for k=1:numPointsToReport
    w = (k-1) * 6;
    errorStandard(w + 1) = (ifdiffStandard{w + 1} - exact{w + 1})/magnitude(exact{w + 1});
    errorStandard(w + 2) = (ifdiffStandard{w + 2} - exact{w + 2})/magnitude(exact{w + 2});
    errGyMinusStandard = (ifdiffStandard{w + 3} - exact{w + 3})/magnitude(exact{w + 3});
    errGpMinusStandard = (ifdiffStandard{w + 4} - exact{w + 4})/magnitude(exact{w + 4});
    errGyPlusStandard  = (ifdiffStandard{w + 5} - exact{w + 5})/magnitude(exact{w + 5});
    errGpPlusStandard  = (ifdiffStandard{w + 6} - exact{w + 6})/magnitude(exact{w + 6});
    errorStandard(w + 3) = max(abs(errGyMinusStandard), [], 'all');
    errorStandard(w + 4) = max(abs(errGpMinusStandard), [], 'all');
    errorStandard(w + 5) = max(abs(errGyPlusStandard), [], 'all');
    errorStandard(w + 6) = max(abs(errGpPlusStandard), [], 'all');

    errorStrict(w + 1) = (ifdiffStrict{w + 1} - exact{w + 1})/magnitude(exact{w + 1});
    errorStrict(w + 2) = (ifdiffStrict{w + 2} - exact{w + 2})/magnitude(exact{w + 2});
    errGyMinusStrict = (ifdiffStrict{w + 3} - exact{w + 3})/magnitude(exact{w + 3});
    errGpMinusStrict = (ifdiffStrict{w + 4} - exact{w + 4})/magnitude(exact{w + 4});
    errGyPlusStrict  = (ifdiffStrict{w + 5} - exact{w + 5})/magnitude(exact{w + 5});
    errGpPlusStrict  = (ifdiffStrict{w + 6} - exact{w + 6})/magnitude(exact{w + 6});
    errorStrict(w + 3) = max(abs(errGyMinusStrict), [], 'all');
    errorStrict(w + 4) = max(abs(errGpMinusStrict), [], 'all');
    errorStrict(w + 5) = max(abs(errGyPlusStrict), [], 'all');
    errorStrict(w + 6) = max(abs(errGpPlusStrict), [], 'all');
end

% And finally display everything as a table
Value = cellfun(@(ch) string(ch), valueNames);
Analytic = cellfun(@(ch) string(ch), Analytic);
Error_Standard = arrayfun(@(err) string(printError(err)), errorStandard);
Error_Strict   = arrayfun(@(err) string(printError(err)), errorStrict);
T = table(Value, Analytic, Error_Standard, Error_Strict)

if plotResults
    T = t0:0.01:tEnd;
    H = deval(solStrict, T, 1);
    V = deval(solStrict, T, 2);
    plot(T, H, 'LineWidth', 2, 'DisplayName', 'h(t)', 'Color', [0 0.5 0.7]);
    hold on;
    plotSolWithJumps([t0 tEnd], solStrict, 2, 'v(t)', 'red', struct(), 'LineWidth', 2);
    hold off;
    plotSensitivitiesSwitched(solStrict, sensFunStrict, [t0 tEnd]);
end

function mag = magnitude(mat)
    % Magnitude (maximum norm) of a matrix, used for computing relative errors. If the matrix is all (nearly)
    % zeros, return 1 instead for the absolute error.
    mag = max(abs(mat), [], 'all');
    if mag < eps
        mag = 1;
    end
end