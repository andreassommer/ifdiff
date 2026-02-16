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
fignum = 1002;
figure(fignum); clf; hold('on');
plotit = @plotter;

% solver selection and configuration
intEuler       = @explEuler;
eulerStep      = 1e-7;
namePlainEuler = @(f) sprintf('plain %s' , func2str(f));

%% COMPUTATION
% Now let the user decide if an euler solution is generated or loaded
fprintf('\nThis is the Euler solution generation script. Proceed with generation?\n');
choices = {"no (load from .mat file)", "yes (can take up to 20 minutes)"};
default_choice_index = 1;
[idx, val] = userchoice(choices, default_choice_index);
doEuler = false;
if idx == 2
    doEuler = true;
end

% EULER Integration
[owndir, ~] = fileparts(mfilename('fullpath'));
euler_fname = fullfile(owndir, sprintf('sol_euler_red_%.0e.mat', eulerStep));
EulerFileIsPresent = isfile(euler_fname);
if EulerFileIsPresent && ~doEuler
    fprintf('Loading sol_euler from file %s\n', euler_fname);
    tmp = load(euler_fname, 'sol_euler_ds');
    sol_euler = tmp.sol_euler_ds;
    doEuler = true;
else
    if ~EulerFileIsPresent
        disp("Euler solution file missing... Generating file");
    else
        disp("Computing Euler solution");
    end
    % Generate euler solution
    fprintf('Integrating with integrator %s (might take a while) ...\n', func2str(intEuler))
    figure(fignum);
    th = tic();
    sol_euler = intEuler(@(t,x) pprhs(t,x,p), tspan, x0_1, eulerStep);
    time_euler = toc(th); fprintf('Euler took %g s\n', time_euler);
    fprintf('Saving result to %s for later reuse.\n', euler_fname);
    % reduce euler solution to make file smaller and save it
    ds = 100;
    idx = 1:ds:numel(sol_euler.x);
    sol_euler_ds.x = sol_euler.x(idx);
    sol_euler_ds.y = sol_euler.y(:, idx);
    save(euler_fname, "sol_euler_ds");
    doEuler = true; % in case we ended up here because the file did not exist
end

if doEuler
    X_euler = X_plot;
    Y_euler = transpose(interp1(sol_euler.x, transpose(sol_euler.y), X_euler));
    linewidth = 2.0;
    hEuler = plotit(fignum, Y_euler, 'c', namePlainEuler(intEuler), linewidth);
end



% FINITO
return

%% HELPERS
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
