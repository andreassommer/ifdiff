function jumps = getJumpIndices_getJumpConditions(datahandle)
%GETJUMPINDICES_GETJUMPCONDITIONS Get the direction flag and ctrlif index of every jump in the RHS and helper functions
% Return a 2xN array whose first row is the direction flags and whose second row is the ctrlif indices of the jumps
    config = makeConfig();
    data = datahandle.getData();
    cIndex = mtree_cIndex();
    mtrees = data.mtreeplus(3, :);
    rIndices = cellfun(@mtree_rIndex, mtrees, 'UniformOutput', false);

    jumps = [];
    for i=1:length(mtrees)
        mtreeobj = mtrees{i};
        rIndex   = rIndices{i};
        if ~isfield(rIndex.BODY, config.jump.internalFunction)
            continue
        end
        ctrljumpArgs  = rIndex.BODY.([config.jump.internalFunction '_Arg']);
        directionFlag = getJumpIndices_parseDirectionFlags(mtreeobj, ctrljumpArgs(:, 2));
        ctrlif_index  = str2double(mtreeobj.C(mtreeobj.T(ctrljumpArgs(:,3), cIndex.stringTableIndex)))';
        jumps         = [jumps [directionFlag; ctrlif_index]];
    end
end