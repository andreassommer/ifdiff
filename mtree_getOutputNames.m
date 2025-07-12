function outputNames = mtree_getOutputNames(mtree, rIndex)
%outputNames = MTREE_GETOUTPUTNAMES(mtree, rIndex)
%
%Get names of all outputs of a function defined in an mtree.
%
%INPUT:
%   mtree - Mtree containing the function definition (as its main function, i.e. not local or nested).
%       mtreeplus
%
%   rIndex - Important row indices of the mtree.
%   If an empty array is passed, the row index will be generated in this function.
%       struct | empty array
%
%OUTPUT:
%   outputNames - Names of the function outputs.
%       1xN cell array of 1x? char array

cIndex = mtree_cIndex();

if isempty(rIndex)
    rIndex = struct('HEAD', struct(), 'BODY', struct());
    rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);
end

rIndexOutput = rIndex.HEAD.Outs;
outputNames = {};
while rIndexOutput ~= 0
    outputNames{end + 1} = mtree.C{mtree.T(rIndexOutput, cIndex.stringTableIndex)}; %#ok<AGROW>
    rIndexOutput = mtree.T(rIndexOutput, cIndex.indexNextNode);
end
end
