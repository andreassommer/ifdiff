function chattering = solveODE_recognizeFilippovSwitching(datahandle)
% This function evaluates the data in 'datahandle' to determine if a 
% Filippov switching event possibly has occured. It does so by
% calculating the local switching frequency and counting the total
% amount of switches occurred so far. If either of these is too high, an
% error/warning is issued. Recognition parameters can be changed by the
% user in the file 'makeConfig.m'.
%
% INPUT:
% 'datahandle': datahandle containing the integration and switching
%               data.
%
% OUTPUT:
% 'chattering': Flag if filippov switching, i.e. chattering has been 
%               detected or not. Is true or false.
%
% Author: Michael Strik, Feb2024
% Email: michael.strik@stud.uni-heidelberg.de
%        michi.strik@gmail.com
    
chattering = false;
    
% get recognition parameters from makeConfig()
config = makeConfig();
swfreqtol           = config.swfreqtol;              % local switching frequency accepted
swfreqtol_checklast = config.swfreqtol_checklast;    % compute local switching frequency based on this many of the last switches
if swfreqtol_checklast < 2
    error('Bad value: config.swfreqtol_checklast should be a positive integer greater than one.\n');
end
swmax               = config.swmax;                  % total amount of switches accepted during integration
    
% get switching data from datahandle
SWP_detection   = datahandle.getData().SWP_detection;
switchingpoints = SWP_detection.switchingpoints;

% compute local switching frequency on the interval spanning the last
% swfreqtol_checklast switches. does it exceed swfreqtol?
iend = length(switchingpoints);
istart = max(1, iend-swfreqtol_checklast+1);
interval_length = switchingpoints{iend} - switchingpoints{istart};
n_switches      = iend - istart + 1;
swfreq          = n_switches/interval_length;
if (swfreq > swfreqtol) && (n_switches >= swfreqtol_checklast)
    chattering = true;
end

% check total amount of switches
n_switches_total = length(switchingpoints);
if n_switches_total > swmax
    chattering = true;
end

% throw error / issue warning
if chattering
    message = ['Switching frequency exceeds local or global tolerance, ' ...
              'potential Filippov switching detected.\n' ...
              'Local switching frequency: %.5g.\n'...
              'Total switching events: %i.\n'];
    if config.swfreq_haltOnWarning
        error('IFDIFF:chattering', message, swfreq, n_switches_total);
    else
        warning('IFDIFF:chattering', message, swfreq, n_switches_total);
    end
end

end