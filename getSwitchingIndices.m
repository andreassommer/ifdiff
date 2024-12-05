function switchingIndices = getSwitchingIndices(datahandle, type)
% get switching indices between timepoint t1 and t3 (type=1), or between t1 and t2 (type=0)
% A switching index is an index into the switch_cond, ctrlif_index, and function_index arrays. A switching index
% corresponds not to a ctrlif, but to one execution of a ctrlif, since a ctrlif can be executed multiple times in
% a single evaluation of the RHS.
% INPUT: datahandle with switch_cond_t1 and switch_cond_t3, as well as the
% corresponding ctrlif_index
% Since the function works by comparing switch_cond arrays element-by-element, it cannot work if they have different
% lengths. In this case, simply return [0].
% To ensure that the signatures have the same lengths, this function should only be run when switch_cond_t2
% or switch_cond_t3 were computed with forced branching.

% type 1: switch between t1 and t3
% type 2: switch between t1 and t2

data = datahandle.getData();

if type == 1
    cond1 = data.SWP_detection.switch_cond_t1;
    cond2 = data.SWP_detection.switch_cond_t3;
else
    cond1 = data.SWP_detection.switch_cond_t1;
    cond2 = data.SWP_detection.switch_cond_t2;
end
if length(cond1) ~= length(cond2)
    switchingIndices = 0;
    return;
end

index = 1:length(cond1);
% check for switching indices, exclude NaNs
switchingIndices = index(cond1 ~= cond2 & ~(isnan(cond1) | isnan(cond2)));

end