function mtreeobj = preprocess_handleNargin(mtreeobj, i)
% when a function contains any nargin then increase it by 2 since
% everyfunction gets two more arguments. 
% Otherwise the function will not behave as the user intended the narargin 
% INTPUT: 'i' -> number that nargin is increased
cIndex = mtree_cIndex(); 
% search for all narargin
nargin_calls_subtree = mtreeobj.mtfind('String', 'nargin'); 
nargin_calls = nargin_calls_subtree.indices; 

if isempty(nargin_calls) 
    return
end 

% when nargin is not initilised in function before, then there is always a
% call node and nargin is the leftchild of this call node
call_node_of_nargin = mtreeobj.T(nargin_calls, cIndex.indexParentNode); 

[nargin_call_parent, nargin_call_parent_connection_type] = mtree_connectionTypeToParent(mtreeobj, call_node_of_nargin); 

% replace call of nargin with ID '(nargin - 2)' 
new_nargin = ['(nargin - ', num2str(i),')']; 
[mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
    nargin_call_parent, ...                                  % from
    nargin_call_parent_connection_type, ...                  % from_type
    {mtreeobj.K.ID, new_nargin}); 

end 