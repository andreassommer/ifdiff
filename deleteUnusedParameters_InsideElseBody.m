
function [mtreeObj, indexStringArray, indexArray, indexStringArrayCount] = ...
        deleteUnusedParameters_InsideElseBody(mtreeobj, outerLoopIndex, bodyIndex, indexStringArray, indexArray, indexStringArrayCount)
    % 
    %
    %
    
    
    % create struct for o.T column access
    cIndex = mtree_cIndex(); 

    
    % get the last node in the if body
    currentNode = bodyIndex;
    if currentNode ~= 0
        while mtreeobj.T(currentNode, cIndex.indexNextNode) ~= 0
            currentNode = mtreeobj.T(currentNode, cIndex.indexNextNode);
        end
        kindNode = mtreeobj.T(currentNode, cIndex.indexLeftchild);
        % going from bottom to top through the body
        while currentNode ~= mtreeobj.T(outerLoopIndex, cIndex.indexLeftchild)
            
            % check if the current node is an assignment or not
            switch mtreeobj.T(currentNode, cIndex.kindOfNode)
                
                % a possible assignment
                case mtreeobj.K.EXPR
                    if mtreeobj.T(kindNode, cIndex.kindOfNode) == mtreeobj.K.EQUALS
                        idNodeIndex = mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexLeftchild);
                    else
                        % no assignment, maybe function call or something else,
                        % warn user
                        
                    end
                    
                    if idNodeIndex ~= 0
                        % getting the index of the id node of the parameter on
                        % the left hand side of the assignment
                        if mtreeobj.T(idNodeIndex, cIndex.indexLeftchild) ~= 0
                            while mtreeobj.T(idNodeIndex, cIndex.kindOfNode) ~= mtreeobj.K.ID
                                idNodeIndex = mtreeobj.T(idNodeIndex, cIndex.indexLeftchild);
                            end
                        end
                        % checking if the index of the stringArr of idNodeIndex is in
                        % indexStringArray
                        if sum(ismember(indexStringArray, indexArray(ismember(indexArray(:,1), idNodeIndex), 2)) > 0)
                            
                            helpTree = select(mtreeobj, mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild));
                            
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
                        else
                            % delete this node
                            if mtreeobj.T(currentNode, cIndex.indexNextNode) ~= 0
                                mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexNextNode), cIndex.indexParentNode) = mtreeobj.T(currentNode, cIndex.indexParentNode);
                                
                                if mtreeobj.T(currentNode, cIndex.indexParentNode) == bodyIndex% if we are at the first node of the else body -> delete right child not next node
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                                else
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexRightchild) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                                end
                            else % if we are at the last node of a body; no next node exist
                                if mtreeobj.T(currentNode, cIndex.indexParentNode) ~= mtreeobj.T(bodyIndex, cIndex.indexParentNode) % if we are at the first node of the else body -> delete right child not next node
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = 0;
                                else % delete the whole else statement
                                    mtreeobj.T(mtreeobj.T(mtreeobj.T(bodyIndex, cIndex.indexParentNode), cIndex.indexParentNode), cIndex.indexNextNode) = 0;
                                end
                            end
                        end
                    end
                    
                    % an if statement
                case mtreeobj.K.IF
                    
                    % get index of the if body
                    ifBodyIndex = mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild);
                    % call deleteUnusedParameterInsideIfBody
                    [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = deleteUnusedParameters_InsideIfBody(mtreeobj, currentNode, ifBodyIndex, indexStringArray, indexArray, indexStringArrayCount);
                    
                    % check if there is a else part
                    if mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode) ~= 0
                        % else part
                        
                        % get index of the body of the else part
                        elseBodyIndex = mtreeobj.T(mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode), cIndex.indexRightchild);
                        
                        % call deleteUnusedParameterInsideElseBody
                        [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = deleteUnusedParameters_InsideElseBody(mtreeobj, currentNode, elseBodyIndex, indexStringArray, indexArray, indexStringArrayCount);
                    end
                    
                    % check if there is still an else part and if the if part
                    % is empty, if both are empty delete if statement
                    if mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode) == 0 && mtreeobj.T(kindNode, cIndex.indexRightchild) == 0
                        % delete if statement
                        % check if there is a next node
                        if mtreeobj.T(currentNode, cIndex.indexNextNode) ~= 0
                            mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexNextNode), cIndex.indexParentNode) = mtreeobj.T(currentNode, cIndex.indexParentNode);
                        end
                        
                        if mtreeobj.T(currentNode, cIndex.indexParentNode) ~= 1
                            mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                            % if we are already in the function node
                        else
                            mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexRightchild) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                        end
                    else % add the parameters that are used in the if condition to the string array
                        helpTree = select(mtreeobj, mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexLeftchild));
                        
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
                    end
                    
                case mtreeobj.K.FOR
                    % call delete unusedParameterInsideForLoop
                    % [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = unusedParameterInsideForLoop(mtreeobj, currentNode, elseBodyIndex, indexStringArray, indexArray, indexStringArrayCount);
                    
                    
                case mtreeobj.K.WHILE
                    % call delete unusedParameterInsideWhileLoop
                    % [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = unusedParameterInsideWhileLoop(mtreeobj, currentNode, elseBodyIndex, indexStringArray, indexArray, indexStringArrayCount);
                    
                    
                    % catch all other possible code snippets
                otherwise
                    % the right hand side contains a node the programm does not
                    % know how to work with -> warn user
            end
            
            % getting the previous node
            currentNode = mtreeobj.T(currentNode, cIndex.indexParentNode);
            kindNode = mtreeobj.T(currentNode, cIndex.indexLeftchild);
        end
    end
    
    % return mtreeObj
    mtreeObj = mtreeobj;

end