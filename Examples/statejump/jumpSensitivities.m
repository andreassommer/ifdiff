% Solve jumpSensitivityRHS with IFDIFF and print out results of
% 1. the analytic solution
% 2. IFDIFF with standard tolerances and FD step, plus relative error
% 3. IFDIFF with strict tolerances and shorter FD step, plus relative error

initPaths();
[t0, tEnd, p, x0] = jumpSensitivityInitdata();

% CONFIGURATION
% Precision settings
solverStandard     = @ode45;
optionsStandard    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
FDstepStandard     = generateFDstep(size(x0,1), length(p));

solverStrict       = @ode45;
optionsStrict      = odeset('AbsTol', 1e-12, 'RelTol', 1e-10);
FDstepStrict       = generateFDstep(size(x0,1), length(p), 'ht', 1e-8, 'hy', 1e-8, 'hp', 1e-8);

% Controlling the table output at the end
% Whether to print out IFDIFF's solution values, or only their relative error
printValues = false;
% Format string for solution/G values. Using string here to avoid braces all over the place in the table later
valueFormatString = "% 10.6f";
% Format string for relative error
errorFormatString = "% .4e";
plotResults = true;


% MAIN

% Analytic solution
tsExact       = 4 * log(4);
xsMinusExact  = 4;
xsPlusExact   = 8;
[Gy1, Gp1, Uy1, Up1, Gy2, Gp2] = jumpSensitivitySensitivities(p, t0, x0, tsExact, xsMinusExact, xsPlusExact);
xEndExact     = sqrt(10 - (4*log(4)) + 64);
GysMinusExact = Gy1(tsExact);
GpsMinusExact = Gp1(tsExact);
GysPlusExact  = Uy1 * GysMinusExact;
GpsPlusExact  = Uy1 * GpsMinusExact + Up1;
GyfExact      = Gy2(tEnd) * GysPlusExact;
GpfExact      = Gy2(tEnd) * GpsPlusExact + Gp2(tEnd);

% IFDIFF solution (standard tolerances)
datahandle = prepareDatahandleForIntegration( ...
    'jumpSensitivityRHS', ...
    'solver', func2str(solverStandard), ...
    'options', optionsStandard);
solStandard = solveODE(datahandle, [t0 tEnd], x0, p);

tsStandard      = solStandard.switches(1);
tsMinusStandard = tsStandard - eps(tsStandard - eps(tsStandard));
xsMinusStandard = deval(solStandard, tsMinusStandard);
xsPlusStandard  = deval(solStandard, tsStandard);
xEndStandard    = deval(solStandard, tEnd);
sensFunStandard = generateSensitivityFunction(datahandle, solStandard, FDstepStandard, 'method', 'VDE', ...
    'CalcGy', true, 'CalcGp', true);
sensStandard = sensFunStandard([t0, tsMinusStandard, tsStandard, tEnd]);
Gy = {sensStandard.Gy};
Gp = {sensStandard.Gp};
GysMinusStandard = Gy{2};
GpsMinusStandard = Gp{2};
GysPlusStandard  = Gy{3};
GpsPlusStandard  = Gp{3};
GyfStandard      = Gy{4};
GpfStandard      = Gp{4};


% IFDIFF solution with strict tolerances. The smaller FDstep makes most of the difference,
% but the strict ODE tolerances also help a little bit
datahandle = prepareDatahandleForIntegration( ...
    'jumpSensitivityRHS', ...
    'solver', func2str(solverStrict), ...
    'options', optionsStrict);
solStrict = solveODE(datahandle, [t0 tEnd], x0, p);

tsStrict      = solStrict.switches(1);
tsMinusStrict = tsStrict - eps(tsStrict - eps(tsStrict));
xsMinusStrict = deval(solStrict, tsMinusStrict);
xsPlusStrict  = deval(solStrict, tsStrict);
xEndStrict    = deval(solStrict, tEnd);
sensFunStrict = generateSensitivityFunction(datahandle, solStrict, FDstepStrict, 'method', 'VDE', ...
    'CalcGy', true, 'CalcGp', true);
sensStrict = sensFunStrict([t0, tsMinusStrict, tsStrict, tEnd]);
Gy = {sensStrict.Gy};
Gp = {sensStrict.Gp};
GysMinusStrict = Gy{2};
GpsMinusStrict = Gp{2};
GysPlusStrict  = Gy{3};
GpsPlusStrict  = Gp{3};
GyfStrict      = Gy{4};
GpfStrict      = Gp{4};

% And print everything in a nice table
Value           = ["t_s";     "x_-(t_s)";       "x_+(t_s)";     "Gy_-(t_s)";      "Gp_-(t_s)"; ...
                   "Gy_+(t_s)";     "Gp_+(t_s)";     "x(t_f)";    "Gy(t_f)";      "Gp(t_f)"];
analyticPoints  = [tsExact;    xsMinusExact;    xsPlusExact;    GysMinusExact;    GpsMinusExact; ...
                   GysPlusExact;    GpsPlusExact;    xEndExact;    GyfExact;    GpfExact];
standardPoints  = [tsStandard; xsMinusStandard; xsPlusStandard; GysMinusStandard; GpsMinusStandard; ...
                   GysPlusStandard; GpsPlusStandard; xEndStandard; GyfStandard; GpfStandard];
strictPoints    = [tsStrict;   xsMinusStrict;   xsPlusStrict;   GysMinusStrict;   GpsMinusStrict; ...
                   GysPlusStrict;   GpsPlusStrict;   xEndStrict;   GyfStrict;   GpfStrict];
standardError   = (standardPoints - analyticPoints) ./ zeroByOne(analyticPoints);
strictError     = (strictPoints   - analyticPoints) ./ zeroByOne(analyticPoints);

printValue = @(x) sprintf(valueFormatString, x);
printError = @(x) sprintf(errorFormatString, x);
Analytic        = arrayfun(printValue, analyticPoints);
IFDIFF_Standard = arrayfun(printValue, standardPoints);
Error_Standard  = arrayfun(printError, standardError);
IFDIFF_Strict   = arrayfun(printValue, strictPoints);
Error_Strict    = arrayfun(printError, strictError);

if printValues
    T = table(Value, Analytic, IFDIFF_Standard, Error_Standard, IFDIFF_Strict, Error_Strict)
else
    T = table(Value, Analytic, Error_Standard, Error_Strict)
end

if plotResults
    plotSolWithJumps([t0 tF], solStrict, 1, 'x(t)', [0 0.5 0.7], struct(), 'LineWidth', 2);
    fig = figure();
    % shift a little so it doesn't exactly cover the solution plot's window
    fig.Position = fig.Position + [32 -32 fig.Position(3) 0];
    jumps = solStrict.switches(find(solStrict.jumps));
    T = jumpLinspace(t0, tF, jumps, 1000);
    sensForPlot = sensFunStrict(T);
    GyForPlot   = {sensForPlot.Gy};
    GpForPlot   = {sensForPlot.Gp};
    subplot(1, 2, 1, 'replace');
    plotPointsWithJumps(T, cellfun(@(x) x(1, 1), GyForPlot), jumps, 'G_{y,1,1}', [0.7 0.4 0], struct(), 'LineWidth', 2);
    subplot(1, 2, 2, 'replace');
    plotPointsWithJumps(T, cellfun(@(x) x(1, 1), GpForPlot), jumps, 'G_{p,1,1}', [0.7 0 0.4], struct(), 'LineWidth', 2);
end

function xsOrOne = zeroByOne(xs)
    % When computing relative errors, replace each element in an array that is 0 by 1 to avoid division by 0.
    xsOrOne = xs .* (xs > eps) + (xs < eps);
end