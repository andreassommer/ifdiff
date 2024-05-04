function obj = deleteUnusedParameters(mtreeobj)
% walk through an mtree object and delete all variables that are not
% used in generating the function's return value.
% 'mtreeobj': mtree object that should be simplified
% 'obj': simplified mtree object
% 
% this function requires a topologically sorted mtree (i.e. which has not been
% manipulated before). If you do have a manipulated mtree, you can fix it with
% `mtreeobj = mtreeplus(mtreeobj.tree2str)`

% create struct for o.T column access
cIndex = mtree_cIndex(); 
rIndex = struct('HEAD', struct(), 'BODY', struct()); 
rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD);

% get string of the return value
cIndex_Outs = mtreeobj.T(rIndex.HEAD.Outs, cIndex.stringTableIndex);
output_variables = mtreeobj.C{cIndex_Outs};

% find all ID nodes of the return values
index_list_output_variables_mtree = mtreeobj.mtfind('String', output_variables); 
index_list_output_variables = index_list_output_variables_mtree.indices; 


% taking the last appearence of the output variables und starting from there
% TODO: cut of everything that comes after the last return value call

returnValueIndex    = index_list_output_variables(end);
currentNode         = returnValueIndex;
while mtreeobj.T(currentNode, cIndex.kindOfNode) ~= mtreeobj.K.EXPR
    currentNode = mtreeobj.T(currentNode, cIndex.indexParentNode);
end
kindNode = mtreeobj.T(currentNode, cIndex.indexLeftchild);

% creating an array of all IDs that are relevant to computing the return value
idStringArray = mtreeobj.C(mtreeobj.T(returnValueIndex, cIndex.stringTableIndex));

% perform a backwards breadth-first search from the return value node, deleting all syntax tree nodes that do not
% (indirectly) contribute to setting the return value. idStringArray contains all IDs that
% are somehow involved in defining the return value, so we can find out which nodes not to delete.
while currentNode ~= rIndex.HEAD.FUNCTION
    switch mtreeobj.T(currentNode, cIndex.kindOfNode)
        % most nodes encountered here will be mtreeobj.K.EQUALS
        case mtreeobj.K.EXPR
            if mtreeobj.T(kindNode, cIndex.kindOfNode) == mtreeobj.K.EQUALS
                idNodeIndex = mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexLeftchild);
            else
                % no assignment, maybe function call or something else,
                % warn user

                % ... or not
            end

            if idNodeIndex ~= 0
                % the LHS may not be a simple variable 'x = 10', but an array assignment like 'x(1,:) = [1 2]`.
                % Loop over it to get the ID of the variable itself
                if mtreeobj.T(idNodeIndex, cIndex.indexLeftchild) ~= 0
                    while mtreeobj.T(idNodeIndex, cIndex.kindOfNode) ~= mtreeobj.K.ID
                        idNodeIndex = mtreeobj.T(idNodeIndex, cIndex.indexLeftchild);
                    end
                end
                % checking if the index of the the variable is in our idStringArray of the IDs that contribute
                % to setting the return value. If it is not, that means it was not found to indirectly contribute
                % to the return value, so we can throw it out.
                if ismember(mtreeobj.C{mtreeobj.T(idNodeIndex, cIndex.stringTableIndex)}, idStringArray)
                    % the RHS of the assignment statement
                    assignmentRhs = subtree(select(mtreeobj, mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild)));

                    % get the indices of all IDs that are used to define the variable
                    subIdIndexList = mtree_mtfind(assignmentRhs, 'Kind', assignmentRhs.K.ID);

                    % and append them to idStringArray
                    newIDArray = mtreeobj.C(mtreeobj.T(subIdIndexList, cIndex.stringTableIndex));
                    newIDArray(~ismember(newIDArray, idStringArray));
                    idStringArray = vertcat(idStringArray, newIDArray);
                else
                    % delete this node
                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexNextNode), cIndex.indexParentNode) = mtreeobj.T(currentNode, cIndex.indexParentNode);

                    if mtreeobj.T(currentNode, cIndex.indexParentNode) ~= 1
                        mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                    else
                        % if we are already in the function head node
                        mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexRightchild) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                    end
                end
            end
        case mtreeobj.K.IF
            ifBodyIndex = mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild);

            % Basically the same loop as here, since the if body is also structured as a singly linked list
            % TODO: unify all these incredibly redundant loops (the other helpers have the same loop)
            [mtreeobj, idStringArray] = ...
                deleteUnusedParameters_InsideIfBody(...
                    mtreeobj, ...
                    currentNode, ...
                    ifBodyIndex, ...
                    idStringArray);
            
            % check if there is an else part
            if mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode) ~= 0
                % else part

                % get index of the body of the else part
                elseBodyIndex = mtreeobj.T(mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode), cIndex.indexRightchild);

                % call deleteUnusedParameterInsideElseBody
                [mtreeobj, idStringArray] = ...
                    deleteUnusedParameters_InsideElseBody(...
                        mtreeobj, ...
                        currentNode, ...
                        elseBodyIndex, ...
                        idStringArray);
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
            [mtreeobj, idStringArray] = ...
               deleteUnusedParameters_addParameterInsideForLoop(mtreeobj, ...
                                         currentNode, ...
                                         idStringArray);
        case mtreeobj.K.WHILE
            [mtreeobj, idStringArray] = ...
                deleteUnusedParameters_addParameterInsideWhileLoop(mtreeobj, ...
                    currentNode, ...
                    idStringArray);
        otherwise
            % the right hand side contains a node the program does not
            % know how to work with -> warn user
    end

    % getting the previous node
    currentNode = mtreeobj.T(currentNode, cIndex.indexParentNode);
    kindNode    = mtreeobj.T(currentNode, cIndex.indexLeftchild);
end

% output
obj = mtreeobj;
end %finito




