function [mtreeobj, idStringArray] = ...
        deleteUnusedParameters_addParameterInsideForLoop(mtreeobj, outerLoopIndex, idStringArray)
    helpTree = subtree(select(mtreeobj, outerLoopIndex));

    % Get all IDs used in the subtree and add them to idStringArray
    subIdIndexList = mtree_mtfind(helpTree, 'Kind', helpTree.K.ID); 
    newIDArray = mtreeobj.C{mtreeobj.T(subIdIndexList, cIndex.stringTableIndex)};
    newIDArray(~ismember(newIDArray, idStringArray))
    idStringArray = vertcat(idStringArray, newIDArray);
end