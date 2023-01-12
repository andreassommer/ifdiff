function switchingIndices = getSwitchingIndices(datahandle, type)
% get switching indices between timepoint t1 and t3;
% INPUT: datahandle with switch_cond_t1 and switch_cond_t3, as well as the
% correpsonding ctrlif_index
% compares only those where the ctrlif_index of t1 and t3 matchs, the
% others can't correspond to a switch.

% type 1: switch between t1 and t3
% type 2: switch between t1 and t2


data = datahandle.getData();

if type == 1
    if length(data.SWP_detection.ctrlif_index_t1) ~= length(data.SWP_detection.ctrlif_index_t3)
        switchingIndices = 0;
        return
    end
    % set diff, compare only those there ctrlif_index matchs 
    index_diff = (data.SWP_detection.ctrlif_index_t1 == data.SWP_detection.ctrlif_index_t3);
    
    
    cond1 = data.SWP_detection.switch_cond_t1(index_diff);
    cond2 = data.SWP_detection.switch_cond_t3(index_diff);
    
    
else
    if length(data.SWP_detection.ctrlif_index_t1) ~= length(data.SWP_detection.ctrlif_index_t2)
        switchingIndices = 0; 
        return
    end 
    % set diff, compare only those there ctrlif_index matchs
    index_diff = (data.SWP_detection.ctrlif_index_t1 == data.SWP_detection.ctrlif_index_t2);
    
    
    cond1 = data.SWP_detection.switch_cond_t1(index_diff);
    cond2 = data.SWP_detection.switch_cond_t2(index_diff);
end

index = 1:length(cond1);
% check for switching indices, exclude NaNs
switchingIndices = index(cond1 ~= cond2 & ~(isnan(cond1) | isnan(cond2)));

end


