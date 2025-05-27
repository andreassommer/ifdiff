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
X_plot = linspace(tspan(1), tspan(end), 1000);
fignum = 1000;
figure(fignum); clf; hold('on');

% solver selection and configuration
intEuler  = @explEuler; % @implEuler; 
intMatlab = @ode45;
intIfdiff = intMatlab;
intOptions = odeset('reltol', 1e-5, 'abstol', 1e-5, 'MaxStep', 0.5);
eulerStep  = 1e-7;
plotit = @plotter;

% select what to do
doEuler        = false;   % false loads from file
doMatlab       = true;
doIfdiff       = true;
doTransformed  = false;
doErrorplot    = true; % compare ifdiff and original
plotPosterImage= false;

% name generators
nameIfdiff = @(f) sprintf('ifdiff/%s', func2str(f));
namePlain  = @(f) sprintf('plain %s' , func2str(f));

%% Mark the initial point
if true
   xx = x0_1;
   hStart = plot3(xx(3), xx(2), xx(1), 'k.', 'MarkerSize', 25, 'DisplayName', 'x_0');
end

%% Plain integration, no treatment of switches
if doMatlab
   fprintf('Integrating with plain %s ...\n', func2str(intMatlab))
   figure(fignum);
   th = tic();
   sol_matlab = intMatlab(@(t,x) pprhs(t,x,p), tspan, x0_1, intOptions);
   time_matlab = toc(th); fprintf('%s took %g s\n', func2str(intMatlab), time_matlab);
   X_matlab = X_plot;
   Y_matlab = deval(sol_matlab, X_matlab);
   linewidth = 1.0;
   hMatlab = plotit(fignum, X_matlab, Y_matlab, 'r', namePlain(intMatlab), linewidth);
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
   linewidth = 3.0;
   hIFDIFF = plotit(fignum, X_ifdiff, Y_ifdiff, 'g', nameIfdiff(intIfdiff), linewidth);
   if plotPosterImage
    hIFDIFF_poster = posterPlotter(fignum+1, Y_ifdiff);
   end
end


%% EULER Integration
if doEuler
   fprintf('Integrating with integrator %s...\n', func2str(intEuler))
   figure(fignum);
   th = tic();
   sol_euler = intEuler(@(t,x) pprhs(t,x,p), tspan, x0_1, eulerStep);
   time_euler = toc(th); fprintf('Euler took %g s\n', time_euler);
else
   fname = sprintf('sol_euler_%.0e.mat', eulerStep);
   fprintf('Loading sol_euler from file %s\n', fname);
   tmp = load(fname, 'sol_euler');
   sol_euler = tmp.sol_euler;
   doEuler = true;
end
X_euler = X_plot;
Y_euler = transpose(interp1(sol_euler.x, transpose(sol_euler.y), X_euler));
linewidth = 2.0;
hEuler = plotit(fignum, X_euler, Y_euler, 'c', namePlain(intEuler), linewidth);


%%
if false
   hPlane = fitplane(Y_ifdiff);
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
function h = fitplane(YY)
   x = YY(3,:);
   y = YY(2,:);
   z = YY(1,:);
   idx = x > 3; 
   xx = x(idx)'; yy=y(idx)'; zz=z(idx)';  % selecting points
   DM = [xx, yy, ones(size(zz))];  % fitting
   B = DM\zz;                      % fitting 
   [X,Y] = meshgrid(linspace(min(x)*1.02,max(x)*1.02,50), linspace(min(y)*1.00,max(y)*1.02,50));
   %[X,Y] = meshgrid(linspace(min(x)-3,max(x)+3,50), linspace(min(y)-0.5,max(y)+0.5,50));
   Z = B(1)*X + B(2)*Y + B(3)*ones(size(X)) - 0.01;
   h = surf(X, Y, Z, 'DisplayName', 'switching manifold');
   set(h,'FaceColor',[0 0.4 1],'FaceAlpha',0.15,'EdgeColor','none');
end


function errorPlot(fignum, x1, y1, y2, intname1, intname2)
   figure(fignum); clf(fignum);
%    ydiff = vecnorm(y2 - y1, 2);
   ydiff = calcDiff(y1, y2);
   semilogy(x1, ydiff, 'LineWidth', 1.0);
   xlabel('t');
   ylabel('||y||_2');
   title(sprintf('difference %s and %s', intname1, intname2));
   drawnow
end



function h = plotter(fignum, x, y, color, name, lw)
   figure(fignum); hold on;
   h = plot3(y(3,:), y(2,:), y(1,:), 'Color', color, 'LineWidth', lw, 'DisplayName', name);
%    view([166 12]); 
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

function h = posterPlotter(fignum, y)
    figure(fignum); hold on;
    color = '#00534a';
    lw = 2.5;
    mark_x1 = plot3(y(3,:), y(2,:), y(1,:), 'Color', color, 'LineWidth', lw);
    xx = y(:,1);
    hStart = plot3(xx(3), xx(2), xx(1), 'k.', 'MarkerSize', 25, 'DisplayName', 'x_0');
    set(gca, 'Color', '#F5F5F5');
    view([97 51]);
    grid on;
    box on;
    xlabel('Predator');
    ylabel('Prey 2');
    zlabel('Prey 1');
    drawnow
    pause(1.0);
    set(fignum, 'Position', [200  250  750  375]);
end


function sol = explEulerFull(rhs, tspan, x0, stepsize)
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



function sol = explEuler(rhs, tspan, x0, stepsize)
   xdim = length(x0);  % get dimension
   % T = linspace(tspan(1), tspan(end), (tspan(end)-tspan(1))/stepsize);
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


function sol = implEuler(rhs, tspan, x0, stepsize)
   xdim = length(x0);  % get dimension
   % T = linspace(tspan(1), tspan(end), (tspan(end)-tspan(1))/stepsize);
   stepcount = (tspan(end)-tspan(1))/stepsize;
   sfac = 0.001; % store factor
   X = zeros(xdim, ceil(stepcount*sfac)+1);
   Xi = reshape(x0, [], 1); 
   X(:,1) = Xi;
   k = 2; nextout = ceil(1 / sfac);
   fsolveopts = optimoptions(@fsolve, 'Display', 'off', 'maxiter', 100);
   for i=2:stepcount
      g = @(x) x - Xi - stepsize*rhs(i*stepsize, x);
      Xi = fsolve(g, Xi, fsolveopts);
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



function diffnorm = calcDiff(yA, yB)
  % laufe durch x-koordinate von yA, und finde nächstgelegene x-Koordinatein yB
  % vergleiche damit.
  % Ansatz: 1) Durchlaufe x von yA in Index i
  %         2) Suche nächstgelegenes x in yB, ausgehend von x(i-100) bi2 y(i+100) in yV
  len = length(yA);
  diffnorm = zeros(len, 1);
  for i = 1:len
     y = yA(:, i);
     % suche passendes x in yB, um den aktuellen Punkt herum
     window = 250;
     j0 = max(1, i-window);
     jf = max(len, j0+window);
     jidx = j0:jf;
     tmpdiff = yB(:, jidx) - repmat(y, [1, length(jidx)]);
     tmpdiff = vecnorm(tmpdiff,2,1);
     diffnorm(i) = min(tmpdiff);
     if ~mod(i, floor(len/10)), fprintf('x'); end
     diffnorm(i) = diffnorm(i) / norm(y);
  end

end