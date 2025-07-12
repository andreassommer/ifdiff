function [ctrlifIndex, rIndex, rIndexArgs] = createCtrlifCallInfo(mtree)
%[ctrlifIndex, rIndex, rIndexArgs] = CREATECTRLIFCALLINFO(mtree)
%
%Retrieve all row indices related to ctrlif function calls in an mtree.
%
%INPUT:
%   mtree - Mtree containing the ctrlif function calls.
%       mtreeplus
%
%OUTPUT:
%   ctrlifIndex - Ctrlif indices of ctrlif calls found in the mtree.
%       1xN array of positive integers
%
%   rIndex - Row indices related to ctrlif calls in the mtree.
%   Each column corresponds to a full row index entry for a ctrlif call.
%   Each row corresponds to a particular type of row index (e.g. CALL, EQUALS, etc.) named by the rIndexName enum.
%       4xN array of positive integers
%
%   rIndexArgs - Row indices of the arguments belonging to a ctrlif call.
%   Each column contains all (six) argument row indices for one ctrlif call.
%       6xN array of positive integers
%
%See also RINDEXNAME, MTREECALLINFO

cIndex = mtree_cIndex();
config = makeConfig();

ctrlifIndex = [];
rIndex = zeros(length(enumeration('rIndexName')), 0);
rIndexArgs = {};

rIndexTmp = struct('HEAD', struct(), 'BODY', struct());
rIndexTmp.HEAD = mtree_rIndex_head(mtree, rIndexTmp.HEAD);
rIndexTmp.BODY = mtree_rIndex_function(mtree, rIndexTmp.HEAD, rIndexTmp.BODY, config.ctrlif.functionName);

if ~isfield(rIndexTmp.BODY, config.ctrlif.functionName)
    % There are no ctrlif calls.
    return
end

% Ctrlif index is stored in the 4th argument of a ctrlif call.
ctrlifIndex = str2double(mtree.C(mtree.T(rIndexTmp.BODY.ctrlif_Arg(:,4), cIndex.stringTableIndex)))';
% Convert rIndex from struct to a matrix
rIndex(end, length(ctrlifIndex)) = 0; % Preallocate
rIndex(rIndexName.Call, :) = rIndexTmp.BODY.ctrlif_call;
rIndex(rIndexName.Equals, :) = rIndexTmp.BODY.ctrlif_Equals;
rIndex(rIndexName.Expr, :) = rIndexTmp.BODY.ctrlif_expr;
rIndex(rIndexName.Fname, :) = rIndexTmp.BODY.ctrlif;
% Store full arg entries column-wise (same as rIndex).
rIndexArgs = rIndexTmp.BODY.ctrlif_Arg';
end
