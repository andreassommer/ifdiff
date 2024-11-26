function helperFunctionCallInfo = createHelperFunctionCallInfo(mtree)
% How it works: 
% 1. Get all nodes corresponding to setFunctionIndex calls
% 2. Extract the arguments.
% 2a. If the second argument is a -1, then we are in the RHS and the function index is stored in the first argument
% 2b. Otherwise, we are in a helper function and the second argument holds the function_index
% 3. Get the expression node of the actual helper function call.
% 4. From there collect more useful nodes for the helper function, i.e. the EXPR, EQUALS, CALL, FNAME, and ARG (if any) nodes.
% Return: For all helper functions, their function index and rIndex of nodes relevant to the function call.

config = makeConfig();
cIndex = mtree_cIndex();

% Find all subtrees of updateFunctionIndex calls and get their row indices
rIndexUpdateFunctionIndex = mtree.mtfind('String', config.function_indexUpdateFunctionName).indices;

% There are no updateFunctionIndex calls
if isempty(rIndexUpdateFunctionIndex)
    helperFunctionCallInfo = [];
    return
end

% Get the first and second argument of the updateFunctionIndex call
rIndexUpdateFunctionIndexCall = mtree.T(rIndexUpdateFunctionIndex, cIndex.indexParentNode)';
rIndexUpdateFunctionIndexArg1 = mtree.T(rIndexUpdateFunctionIndexCall, cIndex.indexRightchild)';
rIndexUpdateFunctionIndexArg2 = mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.indexNextNode)';

% We can acquire the row indices of a helper function call by finding the expression node of the update function
% and then following the nextNode link.
rIndexUpdateFunctionIndexExpr = mtree_findNode(mtree, rIndexUpdateFunctionIndexCall, mtree.K.EXPR);

% Store important row indices for the helper function call in output
helperFunctionCallInfo = MtreeHelperFunctionCallInfo;
helperFunctionCallInfo.rIndexExpr = mtree.T(rIndexUpdateFunctionIndexExpr, cIndex.indexNextNode)'; 
helperFunctionCallInfo.rIndexEquals = mtree.T(helperFunctionCallInfo.rIndexExpr, cIndex.indexLeftchild)';
helperFunctionCallInfo.rIndexCall = mtree.T(helperFunctionCallInfo.rIndexEquals, cIndex.indexRightchild)';
helperFunctionCallInfo.rIndexFname = mtree.T(helperFunctionCallInfo.rIndexCall, cIndex.indexLeftchild)'; 

% Get row indices of function arguments (if any)
% TODO: Clean up the mtree_rIndex_getFunctionArguments function to make this call less awkward
tmpIndex = struct;
tmpIndex.Call = helperFunctionCallInfo.rIndexCall;
tmpIndex = mtree_rIndex_getFunctionArguments(mtree, tmpIndex, 'Call');
helperFunctionCallInfo.rIndexArgs = tmpIndex.Arg;

% Finally, store the function indices of the helper function calls that were found
% Note that the function index and its corresponding rIndex information should be stored at the same position,
% so that we can associate them with each other.

% For the updateFunctionIndex arguments:
% If the second argument is -1, then we are in the RHS and the first argument contains the function index.
% Otherwise, we are in a helper function and the second argument contains the function index.
updateFunctionIndexArg1 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.stringTableIndex)))';

% Note: -1 can be expressed as UMINUS(INT 1) or INT -1
if all(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.kindOfNode) == mtree.K.UMINUS)
    isRhs = true;
else
    updateFunctionIndexArg2 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.stringTableIndex)))';
    isRhs = all(updateFunctionIndexArg2 == -1);
end

if isRhs
    helperFunctionCallInfo.functionIndex = updateFunctionIndexArg1;
else
    helperFunctionCallInfo.functionIndex = updateFunctionIndexArg2;
end
end
