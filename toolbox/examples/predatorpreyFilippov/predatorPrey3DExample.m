%% Predator–Prey Filippov System Comparison Script
% Combines:
%  - IFDIFF integration
%  - Explicit Euler integration (cached)
%  - Naive ode45 comparison
%  - Sensitivity analysis
%  - Sliding mode analysis (alpha + switching function)

clear; clc;

%% Disable Filippov chattering warnings
warning('off','IFDIFF:chattering');

%% =========================
% PARAMETERS
%% =========================

tspan = [0 100];
plot_n = 10000;
plot_t = linspace(tspan(1),tspan(end),plot_n);

% Euler step
eulerStep = 1e-7;

% Parameters
m     = 0.790;
r1    = 0.836;
e     = 0.948;
q1    = 0.772;
aq    = 0.660;
beta2 = 0.896;

q2    = 1.500;
r2    = 0.300;
beta1 = 7.810;

p = [r1 r2 beta1 beta2 q1 q2 m e aq];

% Initial condition
a  = 0.286975;
x0 = [a; a; r1-r2];

% RHS
rhs = @predatorPrey3D_rhs;

%% =========================
% SOLVER SETTINGS
%% =========================

integrator = @ode45;

intOptions = odeset( ...
    'RelTol',1e-10, ...
    'AbsTol',1e-12, ...
    'MaxStep',0.5);

naiveOptions = odeset( ...
    'RelTol',1e-5, ...
    'AbsTol',1e-6, ...
    'MaxStep',0.5);

%% =========================
% EULER FILE HANDLING
%% =========================

[owndir,~] = fileparts(mfilename('fullpath'));
if contains(owndir,'Editor_')
    [owndir,~] = fileparts(matlab.desktop.editor.getActiveFilename);
end

euler_fname = fullfile(owndir, sprintf('sol_euler_%.0e.mat',eulerStep));
solEuler = loadEulerOrCompute(euler_fname,'solEuler',rhs,tspan,x0,p,eulerStep);

%% =========================
% IFDIFF SOLUTION
%% =========================

fprintf('Integrating with IFDIFF...\n');

datahandle = prepareDatahandleForIntegration(rhs,'solver',integrator,'options',intOptions);

configNew = makeConfig();
configNew.storeSlidingInfo = true;
configOld = makeConfig(configNew);

try
    tic
    solIfdiff = solveODE(datahandle,tspan,x0,p);
    time_ifdiff = toc;
catch ME
    makeConfig(configOld);
    rethrow(ME);
end

makeConfig(configOld);

fprintf('IFDIFF runtime: %.4f s\n',time_ifdiff);

%% =========================
% NAIVE ODE SOLUTION
%% =========================

fprintf('Running naive integration...\n')

RHSfun = @(t,y) rhs(t,y,p);

t_naive = linspace(0,100,10000);

tic
[t_naive_sol,Y_naive] = integrator(RHSfun,t_naive,x0,naiveOptions);
toc

%% =========================
% INTERPOLATE ALL SOLUTIONS
%% =========================

X_ifdiff = deval(solIfdiff,plot_t);

X_euler = interp1(solEuler.x,solEuler.y',plot_t)';
X_naive = interp1(t_naive_sol,Y_naive,plot_t)';

%% =========================
% TRAJECTORY PLOT
%% =========================

figure
ax = axes;

plotSol3d(ax,X_ifdiff,'IFDIFF',3,[0 0.447 0.741],'-');
plotSol3d(ax,X_euler,'Euler',2,[0.85 0.325 0.098],'--');
plotSol3d(ax,X_naive,'Naive ODE45',1,'magenta','-');

title('Predator-Prey Filippov Trajectories')

%% =========================
% DIFFERENCE PLOT
%% =========================

figure

diffnorm = calcDiff(X_ifdiff,X_euler);

semilogy(plot_t,diffnorm,'LineWidth',1.5)

xlabel('t')
ylabel('relative difference')
title('IFDIFF vs Euler difference')
grid on

%% =========================
% SENSITIVITY ANALYSIS
%% =========================

wrt_y = 3;
FDstep = generateFDstep(length(x0),length(p));

sensFunVDE = generateSensitivityFunction(datahandle,solIfdiff,FDstep,...
    'method','VDE',...
    'calcGy',true,...
    'calcGp',false);

sensVDE = sensFunVDE(plot_t);

G = arrayfun(@(s) s.Gy(:,wrt_y),sensVDE,'UniformOutput',false);
sens_ifdiff = [G{:}];

%% Euler sensitivity via finite difference

h = 1e-6;

x0_dist = x0;
x0_dist(wrt_y) = x0_dist(wrt_y)+h;

fname_dist = fullfile(owndir,sprintf('sol_euler_disturb_%d.mat',wrt_y));

solEulerDist = loadEulerOrCompute(fname_dist,'solEuler',rhs,tspan,x0_dist,p,eulerStep);

sensEuler = (solEulerDist.y-solEuler.y)/h;

sensEulerInterp = interp1(solEuler.x,sensEuler',plot_t)';

%% Plot sensitivities

for i=1:3

figure

plot(plot_t,sens_ifdiff(i,:),'LineWidth',2)
hold on
plot(plot_t,sensEulerInterp(i,:),'--','LineWidth',2)

xlabel('Time')
ylabel('Sensitivity')
title(sprintf('Sensitivity component %d',i))

legend('IFDIFF','Euler')

grid on

end

%% =========================
% ALPHA + SWITCHING FUNCTION
%% =========================

data = datahandle.getData();

t_alpha = data.sliding.convexification.t;
alpha   = data.sliding.convexification.alpha;

figure
ax = axes;

yyaxis left
plot(t_alpha,alpha,'LineWidth',2)
ylabel('\alpha')

sw = solIfdiff.switchingFunction{1};
sw_x = arrayfun(@(t) sw([],t,deval(solIfdiff,t),p),t_alpha);

yyaxis right
plot(t_alpha,sw_x,'LineWidth',2)

ylabel('Switching Function')

xlabel('t')
grid on
title('Sliding mode convexification')

xline(solIfdiff.switches,'--')

%% Restore warnings
warning('on','IFDIFF:chattering');

disp('Finished.')

%% =====================================================
% HELPERS
%% =====================================================

function sol_euler = loadEulerOrCompute(fname, vname, rhs, tspan, x0, p, step)
if isfile(fname)
    tmp = load(fname, vname);
    sol_euler = tmp.(vname);
    fprintf('Loading %s from file %s\n', vname, fname);
    return
end
fprintf('Integrating with explicit Euler (might take a while) ...\n')
sol_euler = explEuler(rhs, tspan, x0, p, step);
fprintf('Saving result to %s for later reuse.\n', fname);
save(fname, vname);
end

function diffnorm = calcDiff(yA,yB)

len = length(yA);
diffnorm = zeros(len,1);

for i=1:len

y = yA(:,i);

window = 250;
j0 = max(1,i-window);
jf = max(len,j0+window);

jidx = j0:jf;

tmp = yB(:,jidx)-repmat(y,[1 length(jidx)]);
tmp = vecnorm(tmp,2,1);

diffnorm(i)=min(tmp)/norm(y);

end
end

function ax = plotSol3d(ax,x,name,lw,color,ls)

if isempty(ax)
    figure
    ax = axes;
end

hold(ax,'on')

plot3(ax,x(3,:),x(2,:),x(1,:),...
    'DisplayName',name,...
    'LineWidth',lw,...
    'Color',color,...
    'LineStyle',ls)

view(ax,[97 51])

xlabel(ax,'Predator')
ylabel(ax,'Prey 2')
zlabel(ax,'Prey 1')

grid(ax,'on')
box(ax,'on')

legend(ax,'location','northeast')

end