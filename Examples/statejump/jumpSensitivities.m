% Solve jumpSensitivityRHS with IFDIFF and print out results with standard tolerances, strict tolerances, and
% results from an analytic solution.
initPaths();

[t0, tEnd, p, x0] = jumpSensitivityInitdata();

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
optionsStandard    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
FDstepStandard = generateFDstep(size(x0,1), length(p));

integrator         = @ode45;
datahandle = prepareDatahandleForIntegration( ...
    'jumpSensitivityRHS', ...
    'solver', func2str(integrator), ...
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
optionsStrict    = odeset('AbsTol', 1e-12, 'RelTol', 1e-10);
FDstepStrict = generateFDstep(size(x0,1), length(p), 'ht', 1e-9, 'hy', 1e-9, 'hp', 1e-9);

integrator         = @ode45;
datahandle = prepareDatahandleForIntegration( ...
    'jumpSensitivityRHS', ...
    'solver', func2str(integrator), ...
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
                   "Gy_+(t_s)";     "Gp_+(t_s)";     "Gy(t_f)";      "Gp(t_f)"];
analyticPoints  = [tsExact;    xsMinusExact;    xsPlusExact;    GysMinusExact;    GpsMinusExact; ...
                   GysPlusExact;    GpsPlusExact;    GyfExact;    GpfExact];
standardPoints  = [tsStandard; xsMinusStandard; xsPlusStandard; GysMinusStandard; GpsMinusStandard; ...
                   GysPlusStandard; GpsPlusStandard; GyfStandard; GpfStandard];
strictPoints    = [tsStrict;   xsMinusStrict;   xsPlusStrict;   GysMinusStrict;   GpsMinusStrict; ...
                   GysPlusStrict;   GpsPlusStrict;   GyfStrict;   GpfStrict];
standardError   = (standardPoints - analyticPoints) ./ analyticPoints;
strictError     = (strictPoints   - analyticPoints) ./ analyticPoints;

print16 = @(x) sprintf("% 16.16f", x);
Analytic        = arrayfun(print16, analyticPoints);
IFDIFF_Standard = arrayfun(print16, standardPoints);
Error_Standard  = arrayfun(print16, standardError);
IFDIFF_Strict   = arrayfun(print16, strictPoints);
Error_Strict    = arrayfun(print16, strictError);

T = table(Value, Analytic, IFDIFF_Standard, Error_Standard, IFDIFF_Strict, Error_Strict)