function cutSteps_solution(datahandle, name_solution, t_cut)
% cutSteps_solution(datahandle, name_solution, t_cut)
% 
% Cuts off all steps past 't_cut' in the solution object specified in
% 'name_solution'.
%
% INPUT:
%   datahandle:      datahandle, contains the solution object to be cut
%                       handle
%
%   name_solution:  name of the solution object to be cut, one in
%                   {'solution_until_t1', 'solution_until_t2', 'solution_until_t3'}
%                       char array
%   t_cut:          All steps past t_cut are cut.
%                       scalar
%
% OUTPUT:
%   None.

data = datahandle.getData();

switch name_solution
    case 'solution_until_t1'
        solution = data.SWP_detection.solution_until_t1;
    case 'solution_until_t2'
        solution = data.SWP_detection.solution_until_t2;
    case 'solution_until_t3'
        solution = data.SWP_detection.solution_until_t3;
end
t = solution.x; % x: time points

solution.x(t>t_cut)     = [];
solution.y(:, t>t_cut)  = [];

% adjust the interpolation data - depends on the used solver
solver = solution.solver;
switch solver
    case {'ode23', 'ode45', 'ode78', 'ode89'}
        solution.idata.f3d(:, :, t>t_cut)   = [];

    case 'ode15s'
        solution.idata.kvec(t>t_cut)        = [];
        solution.idata.dif3d(:, :, t>t_cut) = [];
    
    case 'ode23s'
        solution.idata.k1(:, t>t_cut)    = [];
        solution.idata.k2(:, t>t_cut)    = [];
    
    case 'ode113'
        solution.idata.klastvec(t>t_cut)    = [];
        solution.idata.phi3d(:, :, t>t_cut) = [];
        solution.idata.psi2d(:, t>t_cut)    = []; 

    case 'ode23t'
        solution.idata.z(:, t>t_cut)    = [];
        solution.idata.znew(:, t>t_cut) = [];

    case 'ode23tb'
        solution.idata.t2(t>t_cut)      = [];
        solution.idata.y2(:, t>t_cut)   = [];

    otherwise
        error('The solver is not known to the programm - can not continue.');
end

switch name_solution
    case 'solution_until_t1'
        data.SWP_detection.solution_until_t1 = solution;
    case 'solution_until_t2'
        data.SWP_detection.solution_until_t2 = solution;
    case 'solution_until_t3'
        data.SWP_detection.solution_until_t3 = solution;
end

datahandle.setData(data);

end