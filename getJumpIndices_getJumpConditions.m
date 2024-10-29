function jumps = getJumpIndices_getJumpConditions(datahandle)
%GETJUMPINDICES_GETJUMPCONDITIONS Get the row index, ctrlif index, and direction flag of every jump in the RHS and
% helper functions. Return a 3xN array whose first row is the row index (of the call expression) is the
% ctrlif indices and whose second row is the direction flags of the jumps.
% This way, we can identify associations between ctrlifs and ctrljumps, and use the direction flag to determine if
% a jump should be applied at a given switching point.
    config = makeConfig();
    data = datahandle.getData();
    cIndex = mtree_cIndex();
    jumpSpec = config.jump.internalFunction;
    mtrees = data.mtreeplus(3, :);
    rIndices = cellfun(@mtree_rIndex, mtrees, 'UniformOutput', false);

    jumps = [];
    for i=1:length(mtrees)
        mtreeobj = mtrees{i};
        rIndex   = rIndices{i};
        if ~isfield(rIndex.BODY, jumpSpec)
            continue
        end
        ctrljumpRIndex = rIndex.BODY.(jumpSpec);
        ctrljumpArgs   = rIndex.BODY.([jumpSpec '_Arg']);
        ctrlif_index   = str2double(mtreeobj.C(mtreeobj.T(ctrljumpArgs(:, 1), cIndex.stringTableIndex)))';
        directionFlag  = getJumpIndices_parseDirectionFlags(mtreeobj, ctrljumpArgs(:, 2));
        jumps          = [jumps [ctrljumpRIndex; ctrlif_index; directionFlag]];
    end
end