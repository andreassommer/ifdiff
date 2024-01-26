function filippov = solveODE_recognizeFilippovSwitching(datahandle)
    filippov = false;
    
    % get recognition parameters
    config = makeConfig();
    swfreqtol           = config.swfreqtol;              % local switching frequency accepted
    swfreqtol_checklast = config.swfreqtol_checklast;    % compute local switching frequency based on this many of the last switches
    swmax               = config.swmax;                  % total amount of switches accepeted during integration
    
    % get switching data
    SWP_detection   = datahandle.getData().SWP_detection;
    switchingpoints = SWP_detection.switchingpoints;

    % check local switching frequency
    iend = length(switchingpoints);
    istart = max(1, iend-swfreqtol_checklast+1);
    interval_length = switchingpoints{iend} - switchingpoints{istart};
    n_switches      = iend - istart + 1;
    swfreq          = n_switches/interval_length;
    if (swfreq > swfreqtol) && (n_switches >= swfreqtol_checklast)
        filippov = true;
    end

    % check total amount of switches
    n_switches_total = length(switchingpoints);
    if n_switches_total > swmax
        filippov = true;
    end

    % throw error / issue warning
    if filippov
        switch config.swfreq_haltOnWarning
            case true
                error(['Switching frequency exceeds local or global tolerance. ' ...
                    'Potential Filippov switching.\n Local switching frequency: %0.5g. Total switches: %i.'], ...
                    swfreq, n_switches_total);
            case false
                warning(['Switching frequency exceeds local or global tolerance. ' ...
                    'Potential Filippov switching.\n Local switching frequency: %0.5g. Total switches: %i.'], ...
                    swfreq, n_switches_total');
        end
    end

end 