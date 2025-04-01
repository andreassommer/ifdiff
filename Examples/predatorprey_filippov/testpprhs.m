%% SETUP
% parameter values p = (r1, r2, beta1, beta2, q1, q2, m, e)
% order as in paper (see rhs file)
m     = 0.790;
r1    = 0.836;
e     = 0.948;
q1    = 0.772;
aq    = 0.660;
q2    = 1.084;
beta2 = 0.896;
r2    = 0.126;
beta1 = 7.8;  % repulsive focus, below curve mu

beta1 = 7.81; q2 = 1.5; r2 = 0.3;

% initial values, parameters
a = 0.286975;
x0_1 = [a ; a ; r1-r2];
x0_2 = x0_1 + [0.001 ; 0.0001 ; 0]; %% disturbed
p = [r1, r2, beta1, beta2, q1, q2, m, e, aq];

tspan = [0 100];
X_plot = linspace(tspan(1), tspan(end), 10000);
fignum = 100;
figure(fignum); clf; hold('on');

% solver selection and configuration
intEuler  = @explEuler;
intMatlab = @ode45;
intIfdiff = intMatlab;
intOptions = odeset('reltol', 1e-5, 'abstol', 1e-5, 'MaxStep', 0.1);
eulerStep  = 1e-5;

% select what to do
doEuler        = true;
doMatlab       = true;
doIfdiff       = true;
doTransformed  = false;
doErrorplot    = true; % compare ifdiff and original

% name generators
nameIfdiff = @(f) sprintf('ifdiff/%s', func2str(f));
namePlain  = @(f) sprintf('plain %s' , func2str(f));


%% Plain integration, no treatment of switches
if doMatlab
   fprintf('Integrating with plain %s ...\n', func2str(intMatlab))
   figure(fignum);
   th = tic();
   sol_matlab = intMatlab(@(t,x) pprhs(t,x,p), tspan, x0_1, intOptions);
   time_matlab = toc(th); fprintf('%s took %g s\n', func2str(intMatlab), time_matlab);
   X_matlab = X_plot;
   Y_matlab = deval(sol_matlab, X_matlab);
   plotit(fignum, X_matlab, Y_matlab, 'r', namePlain(intMatlab));
end

%% IFDIFF
if doIfdiff
   fprintf('Integrating with IFDIFF/%s ...\n', func2str(intIfdiff))
   figure(fignum);
   datahandle = prepareDatahandleForIntegration('pprhs', 'solver', func2str(intIfdiff), 'options', intOptions);
   % profile off; profile clear; profile on
   th = tic();
   sol_ifdiff = solveODE(datahandle, tspan, x0_1, p);
   time_ifdiff = toc(th); fprintf('IFDIFF took %g s\n', time_ifdiff);
   X_ifdiff = X_plot;
   Y_ifdiff = deval(sol_ifdiff, X_ifdiff);
   % profile off; profile viewer
   plotit(fignum, X_ifdiff, Y_ifdiff, 'g', nameIfdiff(intIfdiff));
end

%% EULER Integration
if doEuler
   fprintf('Integrating with integrator %s...\n', func2str(intEuler))
   figure(fignum);
   th = tic();
   sol_euler = intEuler(@(t,x) pprhs(t,x,p), tspan, x0_1, eulerStep);
   time_euler = toc(th); fprintf('Euler took %g s\n', time_euler);
   X_euler = X_plot;
   Y_euler = transpose(interp1(sol_euler.x, transpose(sol_euler.y), X_euler));
   plotit(fignum, X_euler, Y_euler, 'b', namePlain(intEuler));
end

%% TRANSFORMED SYSTEM
if doTransformed
   error('Don''t do that!');
   myfig = figure(fignum); clf(myfig);
   solA = intMatlab(@(t,x) pprhs5(t,x,p), tspan, x0_1, intOptions);
   solB = intMatlab(@(t,x) pprhs5(t,x,p), tspan, x0_2, intOptions);
   xA=solA.x; yA=solA.y; xB=solB.x; yB=solB.y;
   plotit(myfig, xA, yA, 'b');
   plotit(myfig, xB, yB, 'g');
   xlabel('y1'); ylabel('y2'); zlabel('y3');
   fitplane(yB)
   set(gca, 'YDir','reverse')
   height = 1200;
   width = 1920;
   set(myfig, 'Units', 'pixels', 'Position', [0, 0, width, height])
end

% %% LABELS
% if doMatlab || doIfdiff || doTransformed
%     datalabels = {};
%     if doMatlab,      datalabels{end+1} = ['plain ', func2str(intMatlab)]; end
%     if doIfdiff,      datalabels{end+1} = ['ifdiff+',func2str(intIfdiff)];  end
%     if doTransformed, datalabels{end+1} = 'Transformed';                    end
%     legend(datalabels{:});
% end

%% ANALYSIS
if doErrorplot
   if (doIfdiff && doMatlab)
      fignum = fignum + 1; errorPlot(fignum, X_plot, Y_ifdiff, Y_matlab, nameIfdiff(intIfdiff), namePlain(intMatlab))
   end
   if (doMatlab && doEuler)
      fignum = fignum + 1; errorPlot(fignum, X_plot, Y_matlab, Y_euler , namePlain(intMatlab) , namePlain(intEuler));
   end
   if (doIfdiff && doEuler)
      fignum = fignum + 1; errorPlot(fignum, X_plot, Y_ifdiff, Y_euler , nameIfdiff(intIfdiff), namePlain(intEuler));
   end
end

% FINITO
return



%% HELPERS
function p = fitplane(YY)
   x = YY(3,:);
   y = YY(2,:);
   z = YY(1,:);
   idx = x > 5; 
   xx = x(idx)'; yy=y(idx)'; zz=z(idx)';  % selecting points
   DM = [xx, yy, ones(size(zz))];  % fitting
   B = DM\zz;                      % fitting 
   [X,Y] = meshgrid(linspace(min(x)*1.05,max(x)*1.05,50), linspace(min(y)*1.00,max(y)*1.15,50));
   [X,Y] = meshgrid(linspace(min(x)-3,max(x)+3,50), linspace(min(y)-0.5,max(y)+0.5,50));
   Z = B(1)*X + B(2)*Y + B(3)*ones(size(X)) - 0.01;
   h = surf(X, Y, Z);
   set(h,'FaceColor',[1 0.4 0],'FaceAlpha',0.5,'EdgeColor','none');
end


function errorPlot(fignum, x1, y1, y2, intname1, intname2)
   figure(fignum); clf(fignum);
   ydiff = vecnorm(y2 - y1, 2);
   semilogy(x1, ydiff, 'LineWidth', 1.0);
   xlabel('t');
   ylabel('||y||_2');
   title(sprintf('difference %s and %s', intname1, intname2));
   drawnow
end



function plotit(fignum, x, y, color, name)
   figure(fignum); hold on;
   plot3(y(3,:), y(2,:), y(1,:), color, 'LineWidth', 3.0, 'DisplayName', name);
   view([166 12]); 
   grid on;
   box on;
   xlabel('Predator');
   ylabel('Prey 2');
   zlabel('Prey 1');
   legend('location', 'northwest');
   drawnow
   pause(1.0);
end

function sol = explEuler(rhs, tspan, x0, stepsize)
   xdim = length(x0);  % get dimension
   T = linspace(tspan(1), tspan(end), (tspan(end)-tspan(1))/stepsize);
   stepcount = length(T);
   X = zeros(xdim, stepcount);
   X(:,1) = reshape(x0, [], 1); 
   for i=2:stepcount
      X(:,i) = X(:,i-1) + stepsize * rhs(T(i), X(:,i-1));
      if ~mod(i/stepcount, 0.1), fprintf('.'); end
   end
   fprintf('\n')
   sol.x = T;
   sol.y = X;
end