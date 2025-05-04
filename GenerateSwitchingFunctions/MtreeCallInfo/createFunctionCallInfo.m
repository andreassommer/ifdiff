function [functionIndex, rIndex, rIndexArgs] = createFunctionCallInfo(mtree)
%[functionIndex, rIndex, rIndexArgs] = CREATEFUNCTIONCALLINFO(mtree)
%
%Retrieve all row indices related to helper function calls in an mtree.
%
%INPUT:
%   mtree - Mtree containing the helper function calls.
%       mtreeplus
%
%OUTPUT:
%   functionIndex - Function indices of function calls found in the mtree.
%       1xN array of positive integers
%
%   rIndex - Row indices related to function calls in the mtree.
%   Each column corresponds to a full row index entry for a function call.
%   Each row corresponds to a particular type of row index (e.g. CALL, EQUALS, etc.) named by the rIndexName enum.
%       4xN array of positive integers
%
%   rIndexArgs - Row indices of the arguments belonging to a function call.
%   Each cell contains all the argument row indices for one function call.
%       1xN cell array of 1x? array os positive integers
%
%See also RINDEXNAME, MTREECALLINFO

% General overview:
% 1) Get all nodes corresponding to setFunctionIndex calls.
% 2) Retrieve the arguments of setFunctionIndex calls.
% 2a) If second argument is a -1, then the mtree belongs to the RHS => Function index is in the first argument.
% 2b) Otherwise, mtree belongs to a helper function => Function index is in the second argument.
% 3) Get expression node of actual helper function call by moving up in the mtree starting from the setFunctionIndex call.
% 4) From there collect more useful nodes for the helper function, e.g. CALL, EQUALS, etc.

config = makeConfig();
cIndex = mtree_cIndex();

functionIndex = [];
rIndex = zeros(length(enumeration('rIndexName')), 0);
rIndexArgs = {};

% Find all subtrees of setFunctionIndex calls and get their row indices.
rIndexUpdateFunctionIndex = mtree.mtfind('String', config.function_indexUpdateFunctionName).indices;

if isempty(rIndexUpdateFunctionIndex)
    % There are no helper function calls.
    return
end

% Preallocate
rIndex(end, length(rIndexUpdateFunctionIndex)) = 0;

% Get the first and second argument of the setFunctionIndex call.
rIndexUpdateFunctionIndexCall = mtree.T(rIndexUpdateFunctionIndex, cIndex.indexParentNode)';
rIndexUpdateFunctionIndexArg1 = mtree.T(rIndexUpdateFunctionIndexCall, cIndex.indexRightchild)';
rIndexUpdateFunctionIndexArg2 = mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.indexNextNode)';

% Find actual helper function call by checking parents of setFunctionIndex call.
rIndexUpdateFunctionIndexExpr = mtree_findNode(mtree, rIndexUpdateFunctionIndexCall, mtree.K.EXPR);

% Store important row indices for the helper function call in output
rIndex(rIndexName.Expr, :)   = mtree.T(rIndexUpdateFunctionIndexExpr, cIndex.indexNextNode)';
rIndex(rIndexName.Equals, :) = mtree.T(rIndex(rIndexName.Expr, :), cIndex.indexLeftchild)';
rIndex(rIndexName.Call, :)   = mtree.T(rIndex(rIndexName.Equals, :), cIndex.indexRightchild)';
rIndex(rIndexName.Fname, :)  = mtree.T(rIndex(rIndexName.Call, :), cIndex.indexLeftchild)';

% Get row indices of function arguments (if any).
% TODO: Refactor the mtree_rIndex_getFunctionArguments function to make this call less awkward.
tmpIndex = struct();
tmpIndex.Call = rIndex(rIndexName.Call, :);
tmpIndex = mtree_rIndex_getFunctionArguments(mtree, tmpIndex, 'Call');
rIndexArgs = num2cell(tmpIndex.Arg, 2)';

% setFunctionIndex arguments:
% Second argument is -1 => RHS, function index in first argument
% Second argument is not -1 => Helper function, function index in second argument
updateFunctionIndexArg1 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.stringTableIndex)))';

% Note: -1 can be expressed as UMINUS(INT 1) or INT -1 in the mtree.
if any(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.kindOfNode) == mtree.K.UMINUS)
    isRhs = true;
else
    updateFunctionIndexArg2 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.stringTableIndex)))';
    isRhs = any(updateFunctionIndexArg2 == -1);
end

if isRhs
    functionIndex = updateFunctionIndexArg1;
else
    functionIndex = updateFunctionIndexArg2;
end
end
