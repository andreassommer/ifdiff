function [t, sliding_index, signatures] = solveODE_backtrackChattering(datahandle)
% INPUT:
% 'datahandle':         Datahandle containing the integration and switching data.
%                           handle
%
% OUTPUT:
% 't':                  Timepoint where numerical chattering begins, 
%                       i.e. fast switching in one switch.
%                           double
%
% 'sliding_index':      ctrlif_index of switch that is chattering
%                           integer
%
% 'signatures':         signatures involved in the chattering.
%                           cell array of char arrays
%                           
%
% Author: Michael Strik, Jun2024
% Email: michael.strik@stud.uni-heidelberg.de
%        michi.strik@gmail.com


% get parameters
config              = makeConfig();
data                = datahandle.getData();
checklast           = config.swfreqtol_checklast; % we are checking for Filippov switching on this many of the last switches

% get switching data
SWP_detection   = data.SWP_detection;
switchingpoints = cell2mat(SWP_detection.switchingpoints);

% compute statistical measures of switching frequencies
% based on the last 'checklast' switches
switching_frequencies = diff(switchingpoints);
[swfreq_var, swfreq_mean]  = var(switching_frequencies(end-checklast+2:end));
swfreq_sd   = sqrt(swfreq_var);

% determine to which switch to go back
% Idea: Go back until we see the time-distance between switches
% becoming much higher. Use sample standard deviation for decision.
n = length(switching_frequencies);
t = switchingpoints(1); 
% t is the algorithmically determined starting time of the chattering
j = n+2;
for i=n:-1:1
    if switching_frequencies(i) > swfreq_mean+3*swfreq_sd
        t = switchingpoints(i+1);
        j = i+1;
        break;
    end
end

% Determine the chattering switches (or rather the signatures involved)
chattering_switchingpoints = switchingpoints(j:end);
k = length(chattering_switchingpoints);
switchingFunctions = SWP_detection.switchingFunction(end-k+1:end);

signatures = getUniqueSignaturesFromHandle(switchingFunctions);
rhs_name = data.mtreeplus{2,1};
cut_rhs_name = @(sig) sig(length(rhs_name)+2:end); % +2 because rhs name and signature are seperated by a colon
signatures = cellfun(cut_rhs_name, signatures, 'UniformOutput', false);

if length(signatures) > 2 % more than one switch involved --> not supported
    errMsg = 'Encountered chattering that involves more than one switch. Cannot solve.\n';
    error('IFDIFF:chattering', errMsg);
end

sliding_index = SWP_detection.switchingIndices(end);

end