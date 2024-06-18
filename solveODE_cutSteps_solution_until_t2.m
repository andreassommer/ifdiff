function solveODE_cutSteps_solution_until_t2(datahandle, k)
    % Removes k last integration step from ode sol object in datahandle.
    % 
    % INPUT:
    % 'datahandle': datahandle containing the integration and switching
    %               data.
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

% cut solution_until_t2
data.SWP_detection.solution_until_t2 = data.SWP_detection.solution_until_t3; 
% get the solver that is used during the integration
solver = data.SWP_detection.solution_until_t2.solver;

% cut off the last x and y values
data.SWP_detection.solution_until_t2.x(end-k+1:end)     = [];
data.SWP_detection.solution_until_t2.y(:, end-k+1:end)  = [];

% adjust the interpolation data - depends on the used solver
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

datahandle.setData(data); 


end