function mtree = createHelperSwitchingFunction(mtree, newName)
%mtree = CREATEHELPERSWITCHINGFUNCTION(mtree, newName)
%
%Create a new helper switching function from a base helper function.
%
%INPUT:
%   mtree - Mtree containing the helper function used as the base of the new helper switching function.
%       mtreeplus
%
%   newName - Name of the new helper switching function.
%       char array
%
%OUPUT:
%   mtree - Mtree of the new helper switching function.
%   Acquired by changing the name of the base helper function and removing unneeded arguments (function index and datahandle).
%       mtreeplus

cIndex = mtree_cIndex();

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

% Change name of the helper function.
[mtree, ~] = mtree_createAndAdd_NewNode( ...
    mtree, ...
    rIndex.HEAD.ETC2, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, newName} ...
    );
% Remove first and second argument (i.e. function index and datahandle).
mtree = mtree_connectNodes(...
    mtree, ...
    rIndex.HEAD.ETC2,...
    rIndex.HEAD.Arg(1,3),...
    cIndex.indexRightchild ...
    );
end
