function solveODE_cutSteps_solution_until_t2(datahandle, t_cut)
% Removes integration step that exceed time 't_cut' from ode sol object in
% datahandle.
%
% INPUT:
% 'datahandle': datahandle containing the integration and switching data.
%                   handle
%
% 't_cut':      timepoint until which is to be cut (exclusive)
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

% Step 1: In solution object, cut steps past time t_cut
cutSteps_solution(datahandle, 'solution_until_t2', t_cut);

% Step 2: Adjust the switching data
SWP_detection = data.SWP_detection;
switchingpoints = cell2mat(SWP_detection.switchingpoints);

indicesCut = switchingpoints <= t_cut;

SWP_detection.switchingpoints      = SWP_detection.switchingpoints(indicesCut);
SWP_detection.signatureSwitchIndex = SWP_detection.signatureSwitchIndex(indicesCut);
SWP_detection.switchingFunction    = SWP_detection.switchingFunction(indicesCut);
SWP_detection.jumpFunction         = SWP_detection.jumpFunction(indicesCut);
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
data.SWP_detection.signature = data.SWP_detection.signature([true, indicesCut]);

datahandle.setData(data);

% adjust convexification data
cutSteps_convexification(datahandle, t_cut)
end
