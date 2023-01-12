function obj = deleteUnusedParameters(mtreeobj)
% walk through an mtree object and delete all parameters, that are not
% used
% 'mtreeobj': mtree object that should be simplyfied
% 'obj': returned simplyfied mtree object
% 
% this function requires a properly sorted mtree (i.e. which has not been
% manipulated before). Apply mtreeobj = mtreeplus(mtreeobj.tree2str) before
% calling deleteUnusedParameters to solve this.

% create struct for o.T column access
cIndex = mtree_cIndex(); 
rIndex = struct('HEAD', struct(), 'BODY', struct()); 
rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD); 


% build array of strings of all ID nodes
% indexArray has to columns, one 
[indexArray, stringArray] = deleteUnusedParameters_bltStrArr(mtreeobj);

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

% creating an array of all indices which correspond to the strings
% saved in stringArray, that are in the subtree starting at currentNode
indexStringArray    = zeros(length(stringArray), 1);
% adding the index of returnValue to indexStringArray
indexStringArray(1) = indexArray(ismember(indexArray(:,1), returnValueIndex), 2);
% amount of numbers in indexStringArray
indexStringArrayCount = 1;


% BLACKBOX; no clue what happens here [Valentin]
while currentNode ~= rIndex.HEAD.FUNCTION
    % get the kind of node we have and according to it do different
    % things
    % mtreeobj.K.EQUALS is the normal case
    switch mtreeobj.T(currentNode, cIndex.kindOfNode)
        
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
                % checking if the index of the strArr of idNdIdx is in
                % idxStrArr
                if sum(ismember(indexStringArray, indexArray(ismember(indexArray(:,1), idNodeIndex), 2)) > 0)
                    
                    helpTree = subtree(select(mtreeobj, mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild)));
                    
                    % getting all indices of ID nodes in helpTree
                    % subIdList       = helpTree.mtfind('Kind','ID');
                    % subIdIndexList  = subIdList.indices;
                    
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
                    mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexNextNode), cIndex.indexParentNode) = mtreeobj.T(currentNode, cIndex.indexParentNode);
                    
                    if mtreeobj.T(currentNode, cIndex.indexParentNode) ~= 1
                        mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexNextNode) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                        % if we are already in the function node
                    else
                        mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexParentNode), cIndex.indexRightchild) = mtreeobj.T(currentNode, cIndex.indexNextNode);
                    end
                    
                end
            end
            
        case mtreeobj.K.IF
            
            % get index of the if body
            ifBodyIndex = mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexRightchild);
            
            [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = ...
                deleteUnusedParameters_InsideIfBody(...
                    mtreeobj, ...
                    currentNode, ...
                    ifBodyIndex, ...
                    indexStringArray, ...
                    indexArray, ...
                    indexStringArrayCount);
            
            % check if there is a else part
            if mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode) ~= 0
                % else part
                
                % get index of the body of the else part
                elseBodyIndex = mtreeobj.T(mtreeobj.T(mtreeobj.T(currentNode, cIndex.indexLeftchild), cIndex.indexNextNode), cIndex.indexRightchild);
                
                % call deleteUnusedParameterInsideElseBody
                [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = ...
                    deleteUnusedParameters_InsideElseBody(...
                        mtreeobj, ...
                        currentNode, ...
                        elseBodyIndex, ...
                        indexStringArray, ...
                        indexArray, ...
                        indexStringArrayCount);
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
%                 helpTree = subtree(... 
%                                select(mtreeobj, ...
%                                          mtreeobj.T(mtreeobj.T(...
%                                              currentNode, cIndex.indexLeftchild), ...
%                                          cIndex.indexLeftchild) ...
%                                       )...
%                                   );
%

                helpTree = select(mtreeobj,mtreeobj.T(mtreeobj.T(...
                    currentNode, cIndex.indexLeftchild), cIndex.indexLeftchild));

                               
                               
                % getting all indices of ID nodes in helpTree
                % subIdList       = helpTree.mtfind('Kind','ID');
                % subIdIndexList  = subIdList.indices;
                
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
            
            [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = ...
               deleteUnusedParameters_addParameterInsideForLoop(mtreeobj, ...
                                         currentNode, ...
                                         indexStringArray, ...
                                         indexArray, ...
                                         indexStringArrayCount);
            
        case mtreeobj.K.WHILE
            
            [mtreeobj, indexStringArray, indexArray, indexStringArrayCount] = ...
                deleteUnusedParameters_addParameterInsideWhileLoop(mtreeobj, ...
                    currentNode, ...
                    indexStringArray, ...
                    indexArray, ...
                    indexStringArrayCount);
            
        otherwise
            % the right hand side contains a node the programm does not
            % know how to work with -> warn user
    end
    
    % getting the previous node
    currentNode = mtreeobj.T(currentNode, cIndex.indexParentNode);
    kindNode    = mtreeobj.T(currentNode, cIndex.indexLeftchild);
end

% output
obj = mtreeobj;
end %finito




