function mtree = replaceCtrljumpByReturn(mtree, ctrlifIndex, ctrljumpInfo)
%mtree = REPLACECTRLJUMPBYRETURN(mtree, ctrlifIndex, ctrlJumpInfo)
%
%Replace a ctrljump and its associated ctrlif with a return statement containing the jump increment value.
%
%WARNING: This function will potentially invalidate existing row indices of the mtree!
%
%INPUT:
%   mtree - Mtree containing the ctrljump to be replaced.
%       mtreeplus
%
%   ctrlifIndex - Index of the ctrlif associated with the ctrljump to be replaced.
%       positive integer
%
%   ctrlJumpInfo - Contains information that ties ctrlif indices to ctrljump expressions.
%       3xN array of integers
%
%OUPUT:
%   mtree - Modified mtree with the ctrljump and associated ctrlif replaced by the jump update block.
%   The jump increment value computed by the jump update block is set as the new singular output of the function.
%   Additionally, all statements coming after the jump update block are deleted.
%   The mtree is then reparsed and all statements that do not contribute to the new output of the function are removed.
%       mtreeplus

% Example transformation:
% A jump specification
%
% ctrlif(<switchingFunction> >= 0, ..., <ctrlif_index>, ...)
% if ctrljump(<ctrlif_index>, <direction>)
%     ... statements ...
%     ifdiff_update(<update>);
% end
%
% is replaced by
%
% ... statements ...
% jump_increment = <update>
%
% and the function's return variable changed to jump_increment.

cIndex   = mtree_cIndex;
config   = makeConfig();

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

% Find the ctrljump associated with the ctrlif index.
ctrlifIndices = ctrljumpInfo(2, :);
ctrljumpRIndex = ctrljumpInfo(1, ctrlifIndices == ctrlifIndex);

[ifhead, rIndexUpdate] = replaceJumpifByCtrlif_parseJumpSpec(mtree, ctrljumpRIndex, config.jump.internalFunction);

% Create new output variable for the caller function.
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndex.HEAD.HEAD, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, config.jump.jumpFunctionOutputName});

updateCalls = rIndexUpdate.BODY.([config.jump.updateFunction, config.mtree_rIndex_function.Suffix_call]);
updateArgs  = rIndexUpdate.BODY.([config.jump.updateFunction, '_Arg']);
for i = 1:length(updateCalls)
    % Create assignment statement that assigns the increment to the return value.
    rIndexExpr = mtree.T(updateCalls(i), cIndex.indexParentNode);
    rIndexUpdate = updateArgs(i);
    [mtree, rIndexEqualsNew] = mtree_createAndAdd_NewNode(mtree, ...
        rIndexExpr, ...
        cIndex.indexLeftchild, ...
        mtree.K.EQUALS);
    [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
        rIndexEqualsNew, ...
        cIndex.indexLeftchild, ...
        {mtree.K.ID, config.jump.jumpFunctionOutputName});
    mtree = mtree_connectNodes(mtree, ...
        rIndexEqualsNew, ...
        rIndexUpdate, ...
        cIndex.indexRightchild);
end

% Replace the entire if block by only its body.
ifRoot   = mtree.T(ifhead, cIndex.indexParentNode);
ifParent = mtree.T(ifRoot, cIndex.indexParentNode);
ifNext   = mtree.T(ifRoot, cIndex.indexNextNode);
updateBlockFirstNode = mtree.T(ifhead, cIndex.indexRightchild);
updateBlockLastNode  = updateBlockFirstNode;
while mtree.T(updateBlockLastNode, cIndex.indexNextNode) ~= 0
    updateBlockLastNode = mtree.T(updateBlockLastNode, cIndex.indexNextNode) ~= 0;
end
mtree = mtree_connectNodes(mtree, ...
    ifParent, ...
    updateBlockFirstNode, ...
    cIndex.indexNextNode);
mtree = mtree_connectNodes(mtree, ...
    updateBlockLastNode, ...
    ifNext, ...
    cIndex.indexNextNode);

% Reparse the entire mtree and remove everything that is not required for the computation of the new output variable.
% WARNING: This will potentially invalidate existing row indices of the mtree!
mtree = traceReturnStatementToInputs(mtree, updateBlockLastNode);
end
