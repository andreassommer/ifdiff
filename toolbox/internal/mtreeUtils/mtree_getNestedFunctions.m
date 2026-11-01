function [nestedFunctionIndices, nestedFunctionNames] = mtree_getNestedFunctions(mtree)
%Get all nested function definitions within the main function defined in an mtree.
%Local functions (i.e. functions defined after the end of the main function) are not included.
%
% INPUT:
%   mtree - Mtree containing the function definition (as its main function).
%   Note: The mtree has to be topologically sorted, i.e. freshly parsed and not manipulated.
%       mtreeplus
%
% OUTPUT:
%   nestedFunctionIndices - Row indices of the FUNCTION nodes of all nested functions (including nested functions
%   within nested functions).
%       1xN array of positive integer
%
%   nestedFunctionNames - Names of all nested functions.
%       1xN cell array of char array

    cIndex = mtree_cIndex();

    nestedFunctionIndices = [];
    nestedFunctionNames = {};

    mainFunction = find(mtree.T(:, cIndex.kindOfNode) == mtree.K.FUNCTION, 1);
    if isempty(mainFunction)
        % Script file, nothing to do.
        return
    end

    % Since the mtree is topologically sorted, the subtree of a node consists of all rows from the node itself up to its
    % righttreeindex. Local functions are linked to the main function via Next, so they are not part of the subtree of the
    % main function. Nested functions are part of the body of the main function, so they are.
    % Note: mtree_mtfind cannot be used on the subtree here, since it ignores the selection if the mtree contains
    % additional rows (which is the case for freshly parsed mtrees).
    mainFunctionRows = (mainFunction + 1):mtree.T(mainFunction, cIndex.righttreeindex);
    nestedFunctionIndices = mainFunctionRows(mtree.T(mainFunctionRows, cIndex.kindOfNode) == mtree.K.FUNCTION);

    % Path to the name of a function: FUNCTION -(left)-> HEAD -(right)-> ETC2 -(left)-> Fname
    nestedFunctionNames = cell(1, length(nestedFunctionIndices));
    for i = 1:length(nestedFunctionIndices)
        head = mtree.T(nestedFunctionIndices(i), cIndex.indexLeftchild);
        etc2 = mtree.T(head, cIndex.indexRightchild);
        fname = mtree.T(etc2, cIndex.indexLeftchild);
        nestedFunctionNames{i} = mtree.C{mtree.T(fname, cIndex.stringTableIndex)};
    end
end
