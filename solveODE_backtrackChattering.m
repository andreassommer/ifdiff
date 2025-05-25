function [t, sliding_index] = solveODE_backtrackChattering(datahandle)
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
    % Author: Michael Strik, Jun2024
    % Email: michael.strik@stud.uni-heidelberg.de
    %        michi.strik@gmail.com


    % get parameters
    config              = makeConfig();
    data                = datahandle.getData();
    checklast           = config.swfreqtol_checklast; % we are checking for Filippov switching on this many of the last switches

    % get switching data
    SWP_detection   = data.SWP_detection;
    switchingpoints = SWP_detection.switchingpoints;

    % compute statistical measures of switching frequencies
    % based on the last 'checklast' switches
    switching_frequencies = diff(cell2mat(switchingpoints));
    swfreq_mean = mean(switching_frequencies(end-checklast+2:end));
    swfreq_var  = var(switching_frequencies(end-checklast+2:end));
    swfreq_sd   = sqrt(swfreq_var);

    % determine to which switch to go back
    % Idea: Go back until we see the time-distance between switches
    % becoming much higher. Use sample standard deviation for decision.
    n = length(switching_frequencies);
    t = switchingpoints{1}; 
    % t is the algorithmically determined starting time of the chattering
    for i=n:-1:1
        if switching_frequencies(i) > swfreq_mean+3*swfreq_sd
            t = switchingpoints{i+1};
            break;
        end
    end

    % Determine the chattering switches (or rather the signatures involved)
    switchingpoints = cell2mat(switchingpoints);
    chattering_switchingpts = switchingpoints(switchingpoints >=t);
    k = length(chattering_switchingpts);
    switchingFunctions = SWP_detection.switchingFunction(end-k+1:end);
    
    rhs_name = func2str(data.integratorSettings.preprocessed_rhs);
    signatures = getSignatureFromHandle(switchingFunctions, true, rhs_name);
    
    if length(signatures) > 2 % more than one switch involved --> not supported
        errMsg = 'Encountered chattering that involves more than one switch. Cannot solve.\n';
        error('IFDIFF:chattering', errMsg);
    end

    sliding_index = SWP_detection.switchingIndices(end);
    
end