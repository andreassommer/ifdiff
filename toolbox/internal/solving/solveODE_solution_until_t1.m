function solveODE_solution_until_t1(datahandle)
% Copies solution_until_t3 into solution_until_t1 and cuts off the last
% integration step.
% 
% 
% INPUT:
%       datahandle
%           handle
% 
% OUTPUT:
% No output.

% solution_until_t1 is obtained by cutting one step off of solution_until_t3

% copy
data = datahandle.getData();
data.SWP_detection.solution_until_t1 = data.SWP_detection.solution_until_t3;
datahandle.setData(data);

% cut
t_cut = data.SWP_detection.solution_until_t1.x(end-1);
cutSteps_solution(datahandle, 'solution_until_t1', t_cut);
% also cut convexification data
cutSteps_convexification(datahandle, t_cut);

end