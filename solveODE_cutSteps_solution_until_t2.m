function solveODE_cutSteps_solution_until_t2(datahandle, t)
% Removes k last integration step from ode sol object in datahandle.
% 
% INPUT:
% 'datahandle': datahandle containing the integration and switching data.
%                   handle
%
% 't':          timepoint until which is to be cut
%                   double
%
% OUTPUT:
% No return value, but datahandle is modified.
%
%
% Author: Michael Strik, Jun2024
% Email: michael.strik@stud.uni-heidelberg.de
%        michi.strik@gmail.com
%
% Code adapted from solveODE_solution_until_t1.m


data = datahandle.getData(); 

% Step 1: Cut off steps in solution object

% cut off steps past the timepoint t
solution_until_t2 = data.SWP_detection.solution_until_t2;
x = solution_until_t2.x; % x: time points
indices_x_greater_t = find(x>t);
k = length(indices_x_greater_t);

data.SWP_detection.solution_until_t2.x(end-k+1:end)     = [];
data.SWP_detection.solution_until_t2.y(:, end-k+1:end)  = [];

% adjust the interpolation data - depends on the used solver
solver = data.SWP_detection.solution_until_t2.solver;
switch solver
    case {'ode23', 'ode45', 'ode78', 'ode89'}
        data.SWP_detection.solution_until_t2.idata.f3d(:, :, end-k+1:end)   = [];

    case 'ode15s'
        data.SWP_detection.solution_until_t2.idata.kvec(end-k+1:end)        = [];
        data.SWP_detection.solution_until_t2.idata.dif3d(:, :, end-k+1:end) = [];
    
    case 'ode113'
        data.SWP_detection.solution_until_t2.idata.klastvec(end-k+1:end) = [];
        data.SWP_detection.solution_until_t2.idata.phi3d(:, :, end-k+1:end) = [];
        data.SWP_detection.solution_until_t2.idata.psi2d(:, end-k+1:end) = []; 

    case 'ode23t'
        data.SWP_detection.solution_until_t2.idata.z(:, end-k+1:end) = [];
        data.SWP_detection.solution_until_t2.idata.znew(:, end-k+1:end) = [];

    case 'ode23tb'
        data.SWP_detection.solution_until_t2.idata.t2(end-k+1:end) = [];
        data.SWP_detection.solution_until_t2.idata.y2(:, end-k+1:end) = [];

    otherwise
        error('The solver is not known to the programm - can not continue.');
end

% Step 2: Adjust the switching data
SWP_detection = data.SWP_detection;
switchingpoints = cell2mat(SWP_detection.switchingpoints);
k = length(find(switchingpoints>t));

SWP_detection.switchingpoints = SWP_detection.switchingpoints(1:end-k);
SWP_detection.switchingFunction = SWP_detection.switchingFunction(1:end-k);
SWP_detection.jumpFunction = SWP_detection.jumpFunction(1:end-k);
t2 = data.SWP_detection.solution_until_t2.x(end);
x2 = data.SWP_detection.solution_until_t2.y(:,end);
SWP_detection.t2 = t2;
SWP_detection.x2 = {x2, x2};

data.SWP_detection = SWP_detection;
datahandle.setData(data); 
% adjust also signature & co. at t2
[switch_cond_t2, ctrlif_index_t2, function_index_all_t2] = ctrlif_getSignature(...
    datahandle, ...
    t2, ...
    x2 );
data.SWP_detection.switch_cond_t2    = switch_cond_t2;
data.SWP_detection.ctrlif_index_t2   = ctrlif_index_t2;
data.SWP_detection.function_index_t2 = function_index_all_t2;

datahandle.setData(data);

end