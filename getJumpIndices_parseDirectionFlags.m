function flags = getJumpIndices_parseDirectionFlags(mtreeobj, indices)
%GETJUMPINDICES_PARSEDIRECTIONFLAGS Parse direction flags (-1, 0, 1) from an mtree
% Given an mtreeplus and the T-row indices of ctrljump direction
% flags (-1, 0, 1) convert these into the actual numeric values -1, 0, 1
    cIndex = mtree_cIndex();
    flags = zeros(1, length(indices));
    for i=1:length(indices)
        if mtreeobj.T(indices(i), cIndex.kindOfNode) == mtreeobj.K.UMINUS
            flags(i) = -1;
        elseif mtreeobj.T(indices(i), cIndex.kindOfNode) == mtreeobj.K.INT
            flags(i) = str2double(mtreeobj.C{mtreeobj.T(indices(i), cIndex.stringTableIndex)});
        else
            error('direction flags may be -1, 0, or 1, but found: %s', tree2str(Tree(select(mtreeobj, indices(i)))));
        end
    end
end