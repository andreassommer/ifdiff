function computeUpdateFunction(datahandle)
%SOLVEODE_COMPUTEUPDATEFUNCTION Compute the update function for a switch and store it in the datahandle. If
% none is applicable, store an empty array
    data = datahandle.getData();
    jumpCtrlifIndices = computeUpdateFunction_getJumpIndices(datahandle);
    if length(jumpCtrlifIndices) > 1
        error('Multiple jumps apply to the switch at t=%16.16f\n', data.SWP_detection.switchingpoints{end});
    elseif isempty(jumpCtrlifIndices)
        data.SWP_detection.jumpFunction{end + 1} = [];
        datahandle.setData(data);
        return
    else
        fprintf( ...
            'Jump attached to switching index %d (ctrlif index %d)\n', ...
            jumpCtrlifIndices, ...
            data.SWP_detection.ctrlif_index_t1(jumpCtrlifIndices));
        data.SWP_detection.jumpFunction{end + 1} = setUpJumpFunction(datahandle, jumpCtrlifIndices);
        datahandle.setData(data);
    end
end