function [mtreeobj, idStringArray] = ...
        deleteUnusedParameters_walkBodyNodes(mtreeobj, idStringArray, lastNextNode)
    %DELETEUNUSEDPARAMETERS_WALKBODYNODES Walk backwards through an mtree, deleting irrelevant nodes
    % idStringArray initially contains the return variable(s).
    % lastNextNode is the index of the last body node to consider, the ones after it are simply left untouched.
    % The function loops over this last node, then its parent, and so on the head of a function. When handling
    % an assignment statement, the function checks if the variable being assigned is in idStringArray. If
    % so, all variables used in the assignment's RHS are added to idStringArray. If not, the assignment
    % is deleted from the mtree. When handling a body node that is if, for, or while, the function calls
    % itself recursively to process the body of the if/for/while.
    cIndex = mtree_cIndex();
    trueParent = mtreeobj.T(lastNextNode, cIndex.trueParent);
    while lastNextNode ~= trueParent
        lastNextNodeKind = mtreeobj.T(lastNextNode, cIndex.kindOfNode);
        leftChild = mtreeobj.T(lastNextNode, cIndex.indexLeftchild);
        switch lastNextNodeKind
            case mtreeobj.K.EXPR
                if mtreeobj.T(leftChild, cIndex.kindOfNode) ~= mtreeobj.K.EQUALS
                    % expression is not an assignment, better not mess with it
                else
                    assignmentLhs = subtree(select(mtreeobj, mtreeobj.T(leftChild, cIndex.indexLeftchild)));
                    assignedVars = mtree_mtfind(assignmentLhs, 'Kind', assignmentLhs.K.ID);
    
                    % checking if any of the assigned variables are in our idStringArray of the IDs that contribute
                    % to setting the return value
                    if any(ismember(mtreeobj.C(mtreeobj.T(assignedVars, cIndex.stringTableIndex)), idStringArray))
                        % ... if it is, then we add all variables that appear in its RHS to idStringArray
                        assignmentRhs = subtree(select( ...
                                mtreeobj, ...
                                mtreeobj.T(mtreeobj.T(lastNextNode, cIndex.indexLeftchild), cIndex.indexRightchild)) ...
                        );
                        subIdIndexList = mtree_mtfind(assignmentRhs, 'Kind', assignmentRhs.K.ID);
                        newIDArray = mtreeobj.C(mtreeobj.T(subIdIndexList, cIndex.stringTableIndex));
                        newIDArray(~ismember(newIDArray, idStringArray));
                        idStringArray = vertcat(idStringArray, newIDArray);
                    else
                        % ... and if not, we delete this assignment statement:
                        mtreeobj = mtree_deleteBodyNode(mtreeobj, lastNextNode);
                    end
                end
            case mtreeobj.K.IF
                currentBranch = mtreeobj.T(lastNextNode, cIndex.indexLeftchild);
                while currentBranch ~= 0 % iterates over the if, then each elseif, then the else.
                    bodyStartIndex = mtreeobj.T(currentBranch, cIndex.indexRightchild);
                    bodyEndIndex = mtree_lastNextNodeIndex(mtreeobj, bodyStartIndex);
                    [mtreeobj, idStringArray] = deleteUnusedParameters_walkBodyNodes(mtreeobj, idStringArray, bodyEndIndex);
                    currentBranch = mtreeobj.T(currentBranch, cIndex.indexNextNode);
                end

                % if all branches of the condition are empty, delete it
                allBranchesEmpty = true;
                currentBranch = mtreeobj.T(lastNextNode, cIndex.indexLeftchild);
                while allBranchesEmpty && currentBranch ~= 0
                    % as soon as any if/elseif/else has a right child (=body), we know we cannot delete the statement.
                    % Keep in mind that an else block will not execute if a previous elseif applies, so we need to
                    % keep empty branches around, too.
                    if mtreeobj.T(currentBranch, cIndex.indexRightchild) ~= 0
                        allBranchesEmpty = false;
                    end
                    currentBranch = mtreeobj.T(currentBranch, cIndex.indexNextNode);
                end

                if allBranchesEmpty
                    mtreeobj = mtree_deleteBodyNode(mtreeobj, lastNextNode);
                else
                    % otherwise, add the variables from the conditions to idStringArray
                    currentBranch = mtreeobj.T(lastNextNode, cIndex.indexLeftchild);
                    while currentBranch ~= 0 && mtreeobj.T(currentBranch, cIndex.indexLeftchild) ~= 0
                        conditionSubtree = select(mtreeobj, mtreeobj.T(currentBranch, cIndex.indexLeftchild));
                        subIdIndexList = mtree_mtfind(conditionSubtree, 'Kind', conditionSubtree.K.ID);
                        newIDArray = mtreeobj.C(mtreeobj.T(subIdIndexList, cIndex.stringTableIndex));
                        newIDArray = newIDArray(~ismember(newIDArray, idStringArray));
                        idStringArray = vertcat(idStringArray, newIDArray);
                        currentBranch = mtreeobj.T(currentBranch, cIndex.indexNextNode);
                    end
                end
            case {mtreeobj.K.FOR, mtreeobj.K.WHILE}
                % Loops present a difficulty, because this function relies on the notion that "a comes before b in the
                % code" is equivalent to "a is executed before b", which does not apply to loop bodies. I think you
                % could solve it by first collecting the variables from the loop head and body, then running
                % deleteUnusedParameters_walkBodyNodes on the loop body and using these additional variables. For now,
                % though, we'll just collect all variables and not prune any code.
                loopSubtree = subtree(select(mtreeobj, outerLoopIndex));
                subIdIndexList = mtree_mtfind(loopSubtree, 'Kind', helpTree.K.ID); 
                newIDArray = mtreeobj.C{mtreeobj.T(subIdIndexList, cIndex.stringTableIndex)};
                newIDArray(~ismember(newIDArray, idStringArray))
                idStringArray = vertcat(idStringArray, newIDArray);
            otherwise
                warning('deleteUnusedParameters_walkBodyNodes: found unknown node type %s', mtreeobj.KK{lastNextNodeKind});
        end
        lastNextNode = mtreeobj.T(lastNextNode, cIndex.indexParentNode);
    end
end