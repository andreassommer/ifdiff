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


% initial values
a = 0.286975;
x0_1 = [a ; a ; r1-r2];
x0_2 = x0_1 + [0.001 ; 0.0001 ; 0];

p = [r1, r2, beta1, beta2, q1, q2, m, e, aq];
tspanA = [0 100];%2*[0 150];
tspanB = 2*[0 135];
eulerStep = 1e-5;

opts = odeset('reltol', 1e-6, 'abstol', 1e-9, 'MaxStep', 0.1);

doOriginal = true;
doTransformed = false;
doIfdiff = true;
analyzeResults = true; % compare ifdiff and original

integrator = @explEuler;

% plain integration, no treatment of switches
fignum = 333;
if doOriginal
   origSol = integrator(@(t,x) pprhs(t,x,p), tspanA, x0_1, eulerStep);
   plotit(fignum, origSol.x, origSol.y, 'b');
end

if doIfdiff
    filename = 'pprhs';
    ifdiffIntegrator = @ode45;
    datahandle = prepareDatahandleForIntegration(filename, 'solver', func2str(ifdiffIntegrator), 'options', opts);
    %profile off; profile clear; profile on
    ifdiffSol = solveODE(datahandle, tspanA, x0_1, p);
    % profile off; profile viewer
    plotit(fignum, ifdiffSol.x, ifdiffSol.y, 'g');
end

% TRANSFORMED SYSTEM
if doTransformed
   myfig = figure(fignum); clf(fignum);
   solA = integrator(@(t,x) pprhs5(t,x,p), tspanA, x0_1, opts);
   solB = integrator(@(t,x) pprhs5(t,x,p), tspanB, x0_2, opts);
   xA=solA.x; yA=solA.y; xB=solB.x; yB=solB.y;
   
   plotit(fignum, xA, yA, 'b');
   plotit(fignum, xB, yB, 'g');
   xlabel('y1'); ylabel('y2'); zlabel('y3');
   fitplane(yB)
   set(gca, 'YDir','reverse')
   height = 1200;
   width = 1920;
   set(myfig, 'Units', 'pixels', 'Position', [0, 0, width, height])
   
end

if doOriginal || doIfdiff || doTransformed
    datalabels = {};
    if doOriginal,      datalabels{end+1} = ['plain ', func2str(integrator)];       end %#ok<UNRCH> 
    if doIfdiff,        datalabels{end+1} = ['ifdiff+',func2str(ifdiffIntegrator)]; end %#ok<UNRCH> 
    if doTransformed,   datalabels{end+1} = 'Transformed';                          end %#ok<UNRCH>
    legend(datalabels{:});
end

if analyzeResults
    initStep = eulerStep;
    evalEvery = floor(1/initStep*1/10);
    solTime = origSol.x(1:evalEvery:end);
    solDiff = vecnorm(origSol.y(:,1:evalEvery:end) - deval(ifdiffSol, solTime)); %#ok<UNRCH> 
    figDiff = figure(fignum+1); 
    semilogy(solTime, solDiff, 'LineWidth', 1.0);
    xlabel('t');
    ylabel('||y||_2');
    legend(['difference plain ', func2str(integrator), ' and ifdiff+', func2str(ifdiffIntegrator)]);
end

% FINITO


% HELPER
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


function plotit(fignum, x, y, color)
   figure(fignum); hold on;
   plot3(y(3,:), y(2,:), y(1,:), color, 'LineWidth', 3.0);%
   view([166 12]); 
   grid on;
   box on;
   xlabel('Predator');
   ylabel('prey2');
   zlabel('prey1');
   
end

function sol = explEuler(rhs, tspan, x0, stepsize)
   xdim = length(rhs(0,x0));  % get dimension
   T = linspace(tspan(1), tspan(end), (tspan(end)-tspan(1))/stepsize);
   steps = length(T);
   X = zeros(steps, xdim);
   X(1,:) = reshape(x0, 1, []); 
   progress = 0.1;
   for i=2:steps
      X(i,:) = X(i-1,:) + stepsize * rhs(T(i), X(i-1,:))';
      if (i/steps>progress), progress = progress+0.1; fprintf('.'); end
      % if mod(i,150)==0; fprintf('\n'); end % fifddlign
   end
   fprintf('\n')
   sol.x = T;
   sol.y = X';
end