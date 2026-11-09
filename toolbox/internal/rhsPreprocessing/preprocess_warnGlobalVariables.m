function preprocess_warnGlobalVariables(mtree, functionName)
% Issue a warning if the function defined in an mtree declares global variables.
% Global variables are not explicitly supported by IFDIFF, so using them is at the user's own risk.
%
% INPUT:
%   mtree - Freshly parsed mtree of the RHS or of a helper function.
%       mtreeplus
%
%   functionName - Name of the function defined in the mtree (used in the warning message).
%       char array

cIndex = mtree_cIndex();
globalNodes = find(mtree.T(:, cIndex.kindOfNode) == mtree.K.GLOBAL);
if isempty(globalNodes)
    return
end

% The declared variables are the left child of a GLOBAL node and its chain of next nodes.
globalVariableNames = {};
for i = 1:length(globalNodes)
    idNode = mtree.T(globalNodes(i), cIndex.indexLeftchild);
    while idNode ~= 0
        globalVariableNames{end+1} = mtree.C{mtree.T(idNode, cIndex.stringTableIndex)}; %#ok<AGROW>
        idNode = mtree.T(idNode, cIndex.indexNextNode);
    end
end
globalVariableNames = unique(globalVariableNames, 'stable');

msg = [ ...
    'Function ''%s'' uses global variable(s): %s.\n', ...
    'Global variables are not explicitly supported by IFDIFF and may lead to undefined behaviour'];
warning('IFDIFF:Preprocessing:GlobalVariable', msg, functionName, strjoin(globalVariableNames, ', '));
end
