function [mtreeObj, indexStringArray, indexArray, indexStringArrayCount] = deleteUnusedParameters_addParameterInsideForLoop(mtreeobj, outerLoopIndex, indexStringArray, indexArray, indexStringArrayCount)
    %
    %
    %
    %

    helpTree = subtree(select(mtreeobj, outerLoopIndex));

    % getting all indices of ID nodes in helpTree
    % subIdList = helpTree.mtfind('Kind','ID');
    % subIdIndexList = subIdList.indices;
    
    subIdIndexList = mtree_mtfind(helpTree, 'Kind', helpTree.K.ID); 


    % adding all indices of strArr that are in sbIdIdxLs but not in
    % idxStrArr
    % getting all indices of all ID nodes that are in sbIdIdxLs
    newIndexList = indexArray(ismember(indexArray(:,1), subIdIndexList), 2);
    % adding them to idxStrArr
    indexStringArray(indexStringArrayCount + 1: indexStringArrayCount + length(newIndexList)) = newIndexList;

    % adjusting  idxStrArrCnt
    indexStringArrayCount = indexStringArrayCount + length(newIndexList);


    % return mtreeObj
    mtreeObj = mtreeobj;


end