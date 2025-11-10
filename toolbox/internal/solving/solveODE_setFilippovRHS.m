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
[signature1, signature2] = chatteringGetSignatures(datahandle, t);

% only two signatures involved, so we can assume the last switching ctrlif
% to be the chattering one
sliding_index = datahandle.getData().SWP_detection.switchingIndices(end);
if signature1.switchCond(sliding_index) == 1
    signature_fplus = signature1;
    signature_fminus = signature2;
else
    signature_fplus = signature2;
    signature_fminus = signature1;
end

% cut steps
solveODE_cutSteps_solution_until_t2(datahandle, t)

data = datahandle.getData();

% Store signature of Filippov model as combined signatures for sensitivities.
data.SWP_detection.signature{end} = {signature_fplus, signature_fminus};

% get the chattering switch's switching function:
% We ensured there was only a single switch active during chattering,
% so we just pick the switching function of the last switching event.
switchingFunction = data.SWP_detection.switchingfunctionhandles{end};

filippov_rhs = @(datahandle, t, y, p) slidingFilippovRHS_oneSwitch(datahandle, signature_fplus, signature_fminus, switchingFunction,t,y,p);

% set filippov rhs and store some other info
data.sliding.filippov_rhs       = filippov_rhs;
data.sliding.index              = sliding_index;
data.sliding.signature_fplus    = signature_fplus;
data.sliding.signature_fminus   = signature_fminus;

datahandle.setData(data);

if config.debugMode
    fprintf("Entered Filippov regime.\n");
end
end
