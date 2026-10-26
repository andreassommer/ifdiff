function preprocess_warnNestedFunctions(mtree, functionName)
%Issue a warning if the function defined in an mtree contains nested function definitions.
%Nested functions share the workspace of the enclosing function, which is only partially supported by IFDIFF.
%
% INPUT:
%   mtree - Freshly parsed mtree of the RHS or of a helper function.
%       mtreeplus
%
%   functionName - Name of the function defined in the mtree (used in the warning message).
%       char array

[~, nestedFunctionNames] = mtree_getNestedFunctions(mtree);
if isempty(nestedFunctionNames)
    return
end

msg = [ ...
    'Function ''%s'' defines nested function(s): %s.\n', ...
    'Nested functions are only supported if they do not contain switching expressions ', ...
    '(e.g. if, abs, sign, min, max).\n', ...
    'Consider moving such logic into a separate helper function file.'];
warning('IFDIFF:Preprocessing:NestedFunction', msg, functionName, strjoin(nestedFunctionNames, ', '));
end
