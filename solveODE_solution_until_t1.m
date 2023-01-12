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
    case 'ode15s'
        data.SWP_detection.solution_until_t1.idata.kvec(end)        = [];
        data.SWP_detection.solution_until_t1.idata.dif3d(:, :, end) = [];
        
    case {'ode23', 'ode45'}
        data.SWP_detection.solution_until_t1.idata.f3d(:, :, end)   = [];
        
    otherwise
        error('The solver is not known to the programm - can not continue.');
        
end

datahandle.setData(data); 



end