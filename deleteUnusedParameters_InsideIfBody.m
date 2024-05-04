function [mtreeObj, idStringArray] = ...
        deleteUnusedParameters_InsideIfBody(mtreeobj, outerLoopIndex, bodyIndex, idStringArray)
    cIndex = mtree_cIndex; 

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
                        % idStringArray
                        if ismember(mtreeobj.C{mtreeobj.T(idNodeIndex, cIndex.stringTableIndex)}, idStringArray)
                            % the RHS of the assignment statement
                            assignmentRhs = select(mtreeobj,mtreeobj.T(mtreeobj.T(...
                                    currentNode, cIndex.indexLeftchild), cIndex.indexLeftchild));

                            % get the indices of all IDs that are used to define the variable
                            subIdIndexList = mtree_mtfind(assignmentRhs, 'Kind', assignmentRhs.K.ID);

                            % and append them to idStringArray
                            newIDArray = mtreeobj.C(mtreeobj.T(subIdIndexList, cIndex.stringTableIndex));
                            newIDArray = newIDArray(~ismember(newIDArray, idStringArray));
                            idStringArray = vertcat(idStringArray, newIDArray);
                        else
                            % delete this node
                            if mtreeobj.T(currentNode, cIndex.indexNextNode) ~= 0
                                mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexNextNode), cIndex.indexParentNode) = mtreeobj.T(currentNode, cIndex.indexParentNode);
                                
                                if mtreeobj.T(currentNode, cIndex.indexParentNode) ~= mtreeobj.T(outerLoopIndex, cIndex.indexLeftchild)
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                                else % if we are in the first node of the body
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexRightchild) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                                end
                                
                            else % if we are at the last node of a body; no next node exist
                                
                                if mtreeobj.T(currentNode, cIndex.indexParentNode) ~= mtreeobj.T(outerLoopIndex, cIndex.indexLeftchild)
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = 0;
                                else % if we are in the first node of the body
                                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexRightchild) = 0;
                                end
                            end
                        end
                    end
                case mtreeobj.K.IF
                    % get index of the if body
                    ifBodyIndex = mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild);
                    % call deleteUnusedParamterInsideIfBody
                    [mtreeobj, idStringArray] = deleteUnusedParameters_InsideIfBody(mtreeobj, currentNode, ifBodyIndex, idStringArray);
                    
                    % check if there is a else part
                    if mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode) ~= 0
                        % else part
                        
                        % get index of the body of the else part
                        elseBodyIndex = mtreeobj.T(mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode), cIndex.indexRightchild);
                        
                        % call deleteUnusedParamterInsideElseBody
                        [mtreeobj, idStringArray] = deleteUnusedParameters_InsideElseBody(mtreeobj, currentNode, elseBodyIndex, idStringArray);
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
                        ifHeadSubtree = select(mtreeobj,mtreeobj.T(mtreeobj.T(...
                           currentNode, cIndex.indexLeftchild), cIndex.indexLeftchild));

                        % get all IDs that are in the assignment's RHS, and add them to the array of relevant IDs
                        subIdIndexList = mtree_mtfind(ifHeadSubtree, 'Kind', ifHeadSubtree.K.ID); 
                        newIDArray = mtreeobj.C(mtreeobj.T(subIdIndexList, cIndex.stringTableIndex));
                        newIDArray = newIDArray(~ismember(newIDArray, idStringArray));
                        idStringArray = vertcat(idStringArray, newIDArray);
                    end
                case mtreeobj.K.FOR
                    %TODO
                    % call delete unusedParamterInsideForLoop
                    % [mtreeObject, idStringArray] = unusedParamterInsideForLoop(mtreeObject, currentNode, elseBodyIndex, idStringArray);
                case mtreeobj.K.WHILE
                    %TODO
                    % call delete unusedParamterInsideWhileLoop
                    % [mtreeObject, idStringArray] = unusedParamterInsideWhileLoop(mtreeObject, currentNode, elseBodyIndex, idStringArray);
                otherwise
                    %TODO
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