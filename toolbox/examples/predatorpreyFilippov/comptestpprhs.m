%% Turn off warnings corresponding to filippov behaviour
warning('off', 'IFDIFF:chattering');

%% SETUP
% parameter values p = (r1, r2, beta1, beta2, q1, q2, m, e)
% order as in paper (see rhs file)
m     = 0.790;
r1    = 0.836;
e     = 0.948;
q1    = 0.772;
aq    = 0.660;
beta2 = 0.896;

beta1 = 7.81; q2 = 1.5; r2 = 0.3;

% initial values, parameters, timespan
a = 0.286975;
x0_1 = [a ; a ; r1-r2];
p = [r1, r2, beta1, beta2, q1, q2, m, e, aq];
tspan = [0 100];

% configure plotting
X_plot = linspace(tspan(1), tspan(end), 1000);
fignum = 1000;
figure(fignum); clf; hold('on');
plotit = @plotter;

% solver selection and configuration
intEuler    = @explEuler;
eulerStep   = 1e-7;
integrator   = @ode45;
intOptions  = odeset('reltol', 1e-10, 'abstol', 1e-12, 'MaxStep', 0.5);

% name generators
nameIfdiff      = @(f) sprintf('ifdiff/%s (correct)', func2str(f));
namePlainEuler  = @(f) sprintf('plain %s (correct)' , func2str(f));
nameODE45       = @(f) sprintf('naive %s (false)' , func2str(f));
nameODE45_2     = @(f) sprintf('more accurate naive %s' , func2str(f));

%% FIRST TIME RUN TO INITIALIZE THE JUST IN TIME COMPILER
% Run the ifdiff integration once to compile the code and have a better runtime for a later speed check
fprintf("Initializing solver %s ... \n", func2str(integrator));
datahandle = prepareDatahandleForIntegration('pprhs', 'solver', integrator, 'options', intOptions);
solveODE(datahandle, tspan, x0_1, p);
disp("Compilation done...");

%% COMPUTATION
% Compute ifdiff solution as always when running the code
fprintf('Integrating with IFDIFF/%s ...\n', func2str(integrator))
figure(fignum);
datahandle = prepareDatahandleForIntegration('pprhs', 'solver', func2str(integrator), 'options', intOptions);
th = tic();
sol_ifdiff = solveODE(datahandle, tspan, x0_1, p);
time_ifdiff = toc(th); fprintf('IFDIFF took %g s\n', time_ifdiff);
X_ifdiff = X_plot;
Y_ifdiff = deval(sol_ifdiff, X_ifdiff);
linewidth = 3.0;
hIFDIFF = plotit(fignum, Y_ifdiff, 'g', nameIfdiff(integrator), linewidth);

% EULER Integration
[owndir, ~] = fileparts(mfilename('fullpath'));
euler_fname = fullfile(owndir, sprintf('sol_euler_red_%.0e.mat', eulerStep));
EulerFileIsPresent = isfile(euler_fname);
doEuler = true;
if EulerFileIsPresent
    fprintf('Loading sol_euler from file %s\n', euler_fname);
    tmp = load(euler_fname, 'sol_euler_ds');
    sol_euler = tmp.sol_euler_ds;
    doEuler = true;
else
    disp("Euler solution file missing... Terminating comparison.");
    doEuler = false;
    return
end

if doEuler
    X_euler = X_plot;
    Y_euler = transpose(interp1(sol_euler.x, transpose(sol_euler.y), X_euler));
    linewidth = 2.0;
    hEuler = plotit(fignum, Y_euler, 'c', namePlainEuler(intEuler), linewidth);
end

% Compute unmodified ODE45 solution
intOptions2 = odeset('reltol', 1e-5, 'abstol', 1e-6, 'MaxStep', 0.5);
disp("Doing naive integration with base ode45 without IFDIFF...");
tspan2 = linspace(0, 100, 10000);
ode45fun = @(t, y) pprhs(t, y, p);
tnaive = tic(); [t_naive, Y_naive] = ode45(ode45fun, tspan2, x0_1, intOptions2); elapsedTime = toc(tnaive);
disp("Done integrating naively.");
fprintf('Elapsed time: %.4f seconds\n', elapsedTime);
hNaiveODE45 = plotit(fignum, transpose(Y_naive), 'magenta', nameODE45(integrator), 1);

warning('on', 'IFDIFF:chattering');

%% ANALYSIS
fignum2 = fignum + 1;
errorPlot(fignum2, X_plot, Y_ifdiff, Y_euler, nameIfdiff(integrator), namePlainEuler(intEuler));

%% Ask if user wants to experience Euler Solution generation
fprintf('\nDo you want to generate an euler trajectory from scratch? \n');
choices = {"No", "Yes"};
default_choice_index = 1;
[idx, val] = userchoice(choices, default_choice_index);
if idx == 2
    generateEulerSol;
end

fprintf('\nDo you want to generate an "accurate" ode45 solution? (Might take a very long time)\n');
choices2 = {"No (exit script)", "Yes"};
[idx2, val2] = userchoice(choices2, default_choice_index);
if idx2 == 2
    fprintf('Computing naive solution with smaller tolerances (rel = 1e-8, abs = 1e-9)');
    % Takes naive solver about 20 minutes on Marvins machine
    intOptions3 = odeset('reltol', 1e-8, 'abstol', 1e-9, 'MaxStep', 0.5);
    ode45fun = @(t, y) pprhs(t, y, p);
    tnaive = tic(); [t_naive2, Y_naive2] = ode45(ode45fun, tspan2, x0_1, intOptions3); elapsedTime = toc(tnaive);
    disp("Done integrating naively.");
    fprintf('Elapsed time: %.4f seconds\n', elapsedTime);
    hNaiveODE45 = plotit(fignum, transpose(Y_naive2), 'red', nameODE45_2(integrator), 1);
end

% FINITO
return

%% HELPERS
function errorPlot(fignum, x1, y1, y2, intname1, intname2)
   figure(fignum); clf(fignum);
   ydiff = calcDiff(y1, y2);
   semilogy(x1, ydiff, 'LineWidth', 1.0);
   xlabel('t');
   ylabel('||y||_2');
   title(sprintf('difference %s and %s', intname1, intname2));
   drawnow
end


function h = plotter(fignum, y, color, name, lw)
   figure(fignum); hold on;
   h = plot3(y(3,:), y(2,:), y(1,:), 'Color', color, 'LineWidth', lw, 'DisplayName', name);
   view([97 51]);
   grid on;
   box on;
   xlabel('Predator');
   ylabel('Prey 2');
   zlabel('Prey 1');
   legend('location', 'northeast');
   drawnow
   pause(1.0);
   set(fignum, 'Position', [200  250  750  375]);
end


function diffnorm = calcDiff(yA, yB)
  % Go through x-coordinates of yA, find nearest x-coordinate in yB and compare.
  % Algorithm:  1) Go through x of yA in Index i
  %             2) Find nearest x in yB in a window centered around yB(:,i)
  len = length(yA);
  diffnorm = zeros(len, 1);
  for i = 1:len
     y = yA(:, i);
     % find nearest x in yB in a time-window around the timepoint of y
     window = 250;
     j0 = max(1, i-window);
     jf = max(len, j0+window);
     jidx = j0:jf;
     tmpdiff = yB(:, jidx) - repmat(y, [1, length(jidx)]);
     tmpdiff = vecnorm(tmpdiff,2,1);
     diffnorm(i) = min(tmpdiff);
     diffnorm(i) = diffnorm(i) / norm(y);
  end
end


function sol = explEuler(rhs, tspan, x0, stepsize)
   xdim = length(x0);  % get dimension
   stepcount = (tspan(end)-tspan(1))/stepsize;
   sfac = 0.001; % store factor
   X = zeros(xdim, ceil(stepcount*sfac)+1);
   Xi = reshape(x0, [], 1); 
   X(:,1) = Xi;
   k = 2; nextout = ceil(1 / sfac);
   for i=2:stepcount
      Xi = Xi + stepsize * rhs(i*stepsize, Xi);
      if (i == nextout)
         X(:,k) = Xi; k = k + 1; 
         nextout = nextout + ceil(1 / sfac);
      end
      if ~mod(floor(100*i/stepcount), 10), fprintf('.'); end
   end
   fprintf('\n')
   T = linspace(tspan(1), tspan(end), ceil(stepcount*sfac)+1);
   sol.x = T;
   sol.y = X;
end
