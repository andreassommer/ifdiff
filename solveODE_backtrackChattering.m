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


    % get recognition parameters from makeConfig()
    config = makeConfig();
    swfreqtol           = config.swfreqtol;              % local switching frequency accepted
    swfreqtol_checklast = config.swfreqtol_checklast;    % we are checking for Filippov switching on this many of the last switches

    % get switching data from datahandle
    SWP_detection   = datahandle.getData().SWP_detection;
    switchingpoints = SWP_detection.switchingpoints;


    % determine to which switch to go back
    % We go back as long as switching frequence stays below swfreqtol.
    i = length(switchingpoints);
    while switchingpoints{i} - switchingpoints{i-1} < swfreqtol
        i = i-1;

        % break before exceeding the switches taken into account
        % for Filippov switching recognition
        if i-1 < length(switchingpoints) - swfreqtol_checklast + 1
            break;
        end
    end

    % At t, switching at frequency below swfreqtol begins:
    t = switchingpoints{i};


end