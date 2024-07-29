% Example of ifdiff-algorithm to solve IVPs with implicit discontinuities and computation 
% of sensitivities w.r.t. the initial values and w.r.t. the parameters of the corresponding IVP.
% The following commands are adjusted for the canonical example.

%% Preprocessing and Integration 

% The first step is the preprocessing where the datahandle is generated. 
% The ODE solver and the ODE options can be set by the user with name-value pairs. 
% If unspecified, defaults are used.

initPaths();            % Initialise the paths for ifdiff
integrator = @ode45;    % Choose integrator and options
odeoptions = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
        
datahandle = prepareDatahandleForIntegration('canonicalExampleRHS', ...
                                             'integrator', func2str(integrator), ...
                                             'options', odeoptions);
tspan         = [0 20];
initialvalues = [1; 0];
parameters    = 5.437;

sol = solveODE(datahandle, tspan, initialvalues, parameters);  % Returns a Matlab sol structure!

t = 0:0.01:20;      % Evaluation grid
y = deval(sol, t);  % Compatible to Matlab's evaluation functions


%% Plotting 
fignum = 333; fontsize = 14;
fh = figure(fignum); clf; set(fh, 'Units', 'normalized', 'Position', [0.05 1.2 1.1 0.9])
ax=subplot(2,4,[1 2 5 6]); plot(t, y, '.'); title('y(t)')
set(ax,'FontSize',fontsize)
xline(sol.switches(1),'--'); xline(sol.switches(2),'--');


%% Sensitivities:

% Setup FD parameters for computation of df/dy
dim_y  = size(sol.y,1);
dim_p  = length(parameters);
FDstep = generateFDstep(dim_y,dim_p);

% Generate Sensitivity function that can be evaluated at specific time points, configuration by name-value pairs
sensitivity_function = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE');

% Evaluate the sensitivity function (accepts vectors)
t = (sol.switches(1)-0.5):0.001:(sol.switches(2)+0.5);
sensitivities = sensitivity_function(t);

% All the adjustable parameters using name-value pairs are:
%   calcGy                  true/false                                                                       true
%   calcGp                  true/false                                                                       true
%   Gmatrices_intermediate  true/false                                                                       false
%   save_intermediates      true/false                                                                       true    
%   integrator              Function handle for ODE solver in Matlab (e.g. ode45)                            Integrator used in ifdiff               
%   integrator_options      Options struct generated for ODE solver                                          Integrator options used in ifdiff
%   method                  String with VDE/END_piecewise/END_full                                           VDE
%   directions_y            Matrix containing directions for directional derivatives w.r.t initial values.   Identity matrix with dimension n_y
%   directions_p            Matrix containing directions for directional derivatives w.r.t parameters.       Identity matrix with dimension n_p


%% Plotting
fh = figure(fignum);
Gy = {sensitivities.Gy};
Gy11 = cellfun(@(x) x(1,1), Gy);
Gy12 = cellfun(@(x) x(1,2), Gy);
Gy21 = cellfun(@(x) x(2,1), Gy);
Gy22 = cellfun(@(x) x(2,2), Gy);
axh(1)=subplot(2,4,3,'replace'); plot(t, Gy11, 'k.'); xlim([t(1) t(end)]); title('G_{y,11}'); xline(sol.switches(1),'--'); xline(sol.switches(2),'--');
axh(2)=subplot(2,4,4,'replace'); plot(t, Gy12, 'k.'); xlim([t(1) t(end)]); title('G_{y,12}'); xline(sol.switches(1),'--'); xline(sol.switches(2),'--');
axh(3)=subplot(2,4,7,'replace'); plot(t, Gy21, 'k.'); xlim([t(1) t(end)]); title('G_{y,21}'); xline(sol.switches(1),'--'); xline(sol.switches(2),'--');
axh(4)=subplot(2,4,8,'replace'); plot(t, Gy22, 'k.'); xlim([t(1) t(end)]); title('G_{y,22}'); xline(sol.switches(1),'--'); xline(sol.switches(2),'--');
set(axh,'Fontsize',fontsize)
linkaxes(axh,'xy');
%figure(fignum);