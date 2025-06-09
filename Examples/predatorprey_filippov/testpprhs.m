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
intIfdiff   = @ode45;
intOptions  = odeset('reltol', 1e-5, 'abstol', 1e-5, 'MaxStep', 0.5);

% select what to do
doIfdiff    = true;
doEuler     = false; % false lets it load from a file
doErrorplot = true;  % compare ifdiff and plain euler

% name generators
nameIfdiff = @(f) sprintf('ifdiff/%s', func2str(f));
namePlain  = @(f) sprintf('plain %s' , func2str(f));


%% IFDIFF
if doIfdiff
   fprintf('Integrating with IFDIFF/%s ...\n', func2str(intIfdiff))
   figure(fignum);
   datahandle = prepareDatahandleForIntegration('pprhs', 'solver', func2str(intIfdiff), 'options', intOptions);
   th = tic();
   sol_ifdiff = solveODE(datahandle, tspan, x0_1, p);
   time_ifdiff = toc(th); fprintf('IFDIFF took %g s\n', time_ifdiff);
   X_ifdiff = X_plot;
   Y_ifdiff = deval(sol_ifdiff, X_ifdiff);
   linewidth = 3.0;
   hIFDIFF = plotit(fignum, Y_ifdiff, 'g', nameIfdiff(intIfdiff), linewidth);
end


%% EULER Integration
euler_fname = fullfile('.', 'Examples', 'predatorprey_filippov', sprintf('sol_euler_%.0e.mat', eulerStep));
if doEuler
   fprintf('Integrating with integrator %s...\n', func2str(intEuler))
   figure(fignum);
   th = tic();
   sol_euler = intEuler(@(t,x) pprhs(t,x,p), tspan, x0_1, eulerStep);
   time_euler = toc(th); fprintf('Euler took %g s\n', time_euler);
   save(euler_fname, "sol_euler");
else
   fprintf('Loading sol_euler from file %s\n', euler_fname);
   tmp = load(euler_fname, 'sol_euler');
   sol_euler = tmp.sol_euler;
   doEuler = true;
end
X_euler = X_plot;
Y_euler = transpose(interp1(sol_euler.x, transpose(sol_euler.y), X_euler));
linewidth = 2.0;
hEuler = plotit(fignum, Y_euler, 'c', namePlain(intEuler), linewidth);


%% ANALYSIS
if doErrorplot
   if (doIfdiff && doEuler)
      fignum = fignum + 1; errorPlot(fignum, X_plot, Y_ifdiff, Y_euler, nameIfdiff(intIfdiff), namePlain(intEuler))
   end
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
         if ~mod(i/stepcount, 0.1), fprintf('.'); end
      end
   end
   fprintf('\n')
   T = linspace(tspan(1), tspan(end), ceil(stepcount*sfac)+1);
   sol.x = T;
   sol.y = X;
end