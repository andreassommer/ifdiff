function outputNames = mtree_getOutputNames(mtree, rIndex)
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
