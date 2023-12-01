function solveODE_solution_until_t1(datahandle) 
% remove last integration step from ode sol object 
% 
% input: sol object of ODE solver 
% output: sol object of ODE solver with last integration step removed.

data = datahandle.getData(); 

data.SWP_detection.solution_until_t1 = data.SWP_detection.solution_until_t3; 
% get the solver that is used during the integration
solver = data.SWP_detection.solution_until_t1.solver;

% cut off the last x and y values
data.SWP_detection.solution_until_t1.x(end)     = [];
data.SWP_detection.solution_until_t1.y(:, end)  = [];

% adjust the interpolation data - depends on the used solver
switch solver

    case {'ode23', 'ode45', 'ode78', 'ode89'}
        data.SWP_detection.solution_until_t1.idata.f3d(:, :, end)   = [];

    case 'ode15s'
        data.SWP_detection.solution_until_t1.idata.kvec(end)        = [];
        data.SWP_detection.solution_until_t1.idata.dif3d(:, :, end) = [];
    
    case 'ode113'
        data.SWP_detection.solution_until_t1.idata.klastvec(end) = [];
        data.SWP_detection.solution_until_t1.idata.phi3d(:, :, end) = [];
        data.SWP_detection.solution_until_t1.idata.psi2d(:, end) = []; 

    case 'ode23t'
        data.SWP_detection.solution_until_t1.idata.z(:, end) = [];
        data.SWP_detection.solution_until_t1.idata.znew(:, end) = [];

    case 'ode23tb'
        data.SWP_detection.solution_until_t1.idata.t2(end) = [];
        data.SWP_detection.solution_until_t1.idata.y2(:, end) = [];

    otherwise
        error('The solver is not known to the programm - can not continue.');
        
end

datahandle.setData(data); 



end