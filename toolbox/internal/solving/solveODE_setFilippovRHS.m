function solveODE_setFilippovRHS(datahandle)
% Sets datahandle.sliding.filippovRHS to a RHS that allows to slide/run
% on the zero-manifold associated to a function that is inconsistently switching.
%
% INPUT:
% 'datahandle':         datahandle containing the integration and
%                       switching data.
%
% OUTPUT:
% No output.
%
%
% Author: Michael Strik, Jun2024
% Email: michael.strik@stud.uni-heidelberg.de
%        michi.strik@gmail.com

config = makeConfig();

% determine where to go back
t = solveODE_backtrackChattering(datahandle);

% determine the signatures involved
signatures = chatteringGetSignatures(datahandle, t);

% TODO: How should the index of the chattering ctrlif be determined? For now assume last ctrlif is chattering.
sliding_index = datahandle.getData().SWP_detection.switchingIndices(end);
% Ensure that first signature has non-negative switching function value, i.e. switchCond is 1/true
if signatures(1).switchCond(sliding_index) ~= 1
    % Need to swap.
    signatures([1 2]) = signatures([2 1]);
end

% cut steps
solveODE_cutSteps_solution_until_t2(datahandle, t)

data = datahandle.getData();

% get the chattering switch's switching function:
% We ensured there was only a single switch active during chattering,
% so we just pick the switching function of the last switching event.
% TODO: Is that assumption actually valid?
switchingFunction = data.SWP_detection.switchingfunctionhandles{end};

filippov_rhs = @(datahandle, t, y, p) slidingFilippovRHS_oneSwitch(datahandle, signatures, switchingFunction, t, y, p);

% Store information about the sliding mode submodel in datahandle
data.sliding.filippov_rhs = filippov_rhs;
data.sliding.index = sliding_index;
data.SWP_detection.signature{end} = signatures;
datahandle.setData(data);

if config.debugMode
    fprintf("Entered Filippov regime.\n");
end
end
