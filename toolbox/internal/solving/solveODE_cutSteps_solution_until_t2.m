function solveODE_cutSteps_solution_until_t2(datahandle, t_cut)
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
t = solution_until_t2.x; % x: time points

data.SWP_detection.solution_until_t2.x(t>t_cut)     = [];
data.SWP_detection.solution_until_t2.y(:, t>t_cut)  = [];

% adjust the interpolation data - depends on the used solver
solver = data.SWP_detection.solution_until_t2.solver;
switch solver
    case {'ode23', 'ode45', 'ode78', 'ode89'}
        data.SWP_detection.solution_until_t2.idata.f3d(:, :, t>t_cut)   = [];

    case 'ode15s'
        data.SWP_detection.solution_until_t2.idata.kvec(t>t_cut)        = [];
        data.SWP_detection.solution_until_t2.idata.dif3d(:, :, t>t_cut) = [];
    
    case 'ode113'
        data.SWP_detection.solution_until_t2.idata.klastvec(t>t_cut)    = [];
        data.SWP_detection.solution_until_t2.idata.phi3d(:, :, t>t_cut) = [];
        data.SWP_detection.solution_until_t2.idata.psi2d(:, t>t_cut)    = []; 

    case 'ode23t'
        data.SWP_detection.solution_until_t2.idata.z(:, t>t_cut)    = [];
        data.SWP_detection.solution_until_t2.idata.znew(:, t>t_cut) = [];

    case 'ode23tb'
        data.SWP_detection.solution_until_t2.idata.t2(t>t_cut)      = [];
        data.SWP_detection.solution_until_t2.idata.y2(:, t>t_cut)   = [];

    otherwise
        error('The solver is not known to the programm - can not continue.');
end

% Step 2: Adjust the switching data
SWP_detection = data.SWP_detection;
switchingpoints = cell2mat(SWP_detection.switchingpoints);

SWP_detection.switchingpoints   = SWP_detection.switchingpoints(switchingpoints<=t_cut);
SWP_detection.switchingFunction = SWP_detection.switchingFunction(switchingpoints<=t_cut);
SWP_detection.jumpFunction      = SWP_detection.jumpFunction(switchingpoints<=t_cut);
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
% note: signature keeps length(switchingpoints)+1 entries, one entry for
% the initial signature
data.SWP_detection.signature.ctrlif_index   = data.SWP_detection.signature.ctrlif_index([true, switchingpoints<=t_cut]);
data.SWP_detection.signature.function_index = data.SWP_detection.signature.function_index([true, switchingpoints<=t_cut]);
data.SWP_detection.signature.switch_cond    = data.SWP_detection.signature.switch_cond([true, switchingpoints<=t_cut]);

datahandle.setData(data);

end