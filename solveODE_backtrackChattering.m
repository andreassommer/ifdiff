function t = solveODE_backtrackChattering(datahandle)
    % INPUT:
    % 'datahandle': 
    %       Datahandle containing the integration and switching data.
    %
    %
    % OUTPUT:
    % 't':  Timepoint where numerical chattering begins, i.e., fast
    %       switching in one switch.
    %
    % Author: Michael Strik, Jun2024
    % Email: michael.strik@stud.uni-heidelberg.de
    %        michi.strik@gmail.com


    % get parameters
    config              = makeConfig();
    swfreqtol           = config.swfreqtol; % local switching frequency accepted
    checklast           = config.swfreqtol_checklast; % we are checking for Filippov switching on this many of the last switches

    % get switching data
    SWP_detection   = datahandle.getData().SWP_detection;
    switchingpoints = SWP_detection.switchingpoints;

    % compute statistical measures of switching frequencies
    % based on the last 'checklast' switches
    switching_frequencies = diff(switchingpoints);
    swfreq_mean = mean(switching_frequencies(end-checklast+2:end));
    swfreq_var  = var(switching_frequencies(end-checklast+2:end));
    swfreq_sd   = sqrt(swfreq_var);

    % determine to which switch to go back
    % Idea: Go back until we see the time-distance between switches
    % becoming much higher. Use sample standard deviation for decision.
    n = length(switching_frequencies);
    t = switchingpoints(1); 
    % t is the algorithmically determined starting time of the chattering
    for i=n:-1:1
        if switching_frequencies(i) > swfreq_mean+3*swfreq_sd
            t = switchingpoints(i+1);
            break;
        end
    end

end