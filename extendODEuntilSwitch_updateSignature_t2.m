function extendODEuntilSwitch_updateSignature_t2(datahandle)

data = datahandle.getData();
[switch_cond_t2, ctrlif_index_t2, function_index_all_t2] = ctrlif_getSignature(...
    datahandle, ...
    data.SWP_detection.t2, ...
    deval(data.SWP_detection.solution_until_t2, data.SWP_detection.t2));


data.SWP_detection.switch_cond_t2    = switch_cond_t2;
data.SWP_detection.ctrlif_index_t2   = ctrlif_index_t2;
data.SWP_detection.function_index_t2 = function_index_all_t2;


datahandle.setData(data);
end

