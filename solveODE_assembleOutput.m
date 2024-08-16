function out = solveODE_assembleOutput(datahandle, n)
% assemble output as requested by user. Delete .SWP_detection from data (is changed/
% overwritten in every switching point detection step, i.e. not exploitable
% furthermore).
%
% INPUT:
% datahandle: datahandle from the integraions process with switching
%             point detection
% n: nargout
%
% OUTPUT: output for the function solveODE

data = datahandle.getData();



numSwitches = length(data.SWP_detection.switchingpoints);
switches = zeros(1, numSwitches);
jumps    = zeros(1, numSwitches);

for i = 1:numSwitches
    switches(1, i) = data.SWP_detection.switchingpoints{i};
    jumps(1, i) = ~isempty(data.SWP_detection.jumpFunction{i});
end


ode_output.solver = data.SWP_detection.solution_until_t3.solver;
ode_output.extdata = data.SWP_detection.solution_until_t3.extdata;
ode_output.x = data.SWP_detection.solution_until_t3.x;
ode_output.y = data.SWP_detection.solution_until_t3.y;
ode_output.stats = data.SWP_detection.solution_until_t3.stats;
ode_output.idata = data.SWP_detection.solution_until_t3.idata;
ode_output.switches = switches;
ode_output.jumps = jumps;
ode_output.switchingFunction = data.SWP_detection.switchingFunction;
ode_output.signature = data.SWP_detection.signature;

out{1} = ode_output;

% solution until t4, if the switching point detection is done, t4 =
% tspan(2), i.e. .solution_until_t4 is the ode solution object to the
% rhs
if n == 1
    out{1} = ode_output; 
end

if n == 2
    data = rmfield(data, 'SWP_detection');
    out = cell(1,2);
    out{1} = ode_output; 
    out{2} = data; 
end


end









