function [rIndex] = mtree_rIndex(mtreeobj, varargin)
% get rIndex of a function call of a mtree, e.g. the row indices of a
% .rawdump function call in a mtree
% 
% INPUT:
% mtreeobj: mtree object
% 
% OUTPUT: 
%     If exits in the mtree it gets a struct with the row indices of: 
%     (when they exist in mtreeobj) 
% 
%     Part 1: FUNCTION HEAD, i.e. FUNCTION Node, Output (Outs), Input (Ins), ....
%     Part 2: lastNextNodeOfBody
%     Part 3: All max and min and their arguments etc.
%     Part 4: All IIf and their arguments etc.
%     Part 5: All ctrlif and their arguments etc. 
%     Part 6: All if and their arguments etc.
%     Part 7: All abs and their arguments etc.

config = makeConfig(); 


% notation:
% cIndex -> column index; refers to a property type
rIndex = struct('HEAD', struct(), 'BODY', struct()); 
rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD); 

rIndex.BODY = mtree_rIndex_lastNextNodeOfBody(mtreeobj, rIndex.BODY, rIndex.HEAD.BODY); 

%rIndex.BODY = mtree_rIndex_Ctrlif(mtreeobj, rIndex.BODY); 
rIndex.BODY = mtree_rIndex_If(mtreeobj, rIndex.BODY); 

rIndex.BODY = mtree_rIndex_function(mtreeobj, rIndex.BODY, config.ctrlif.ctrlif); 
rIndex.BODY = mtree_rIndex_function(mtreeobj, rIndex.BODY, 'IIf'); %
rIndex.BODY = mtree_rIndex_function(mtreeobj, rIndex.BODY, 'abs'); 
rIndex.BODY = mtree_rIndex_function(mtreeobj, rIndex.BODY, 'max'); 
rIndex.BODY = mtree_rIndex_function(mtreeobj, rIndex.BODY, 'min'); 
rIndex.BODY = mtree_rIndex_function(mtreeobj, rIndex.BODY, 'sign');

if ~isempty(varargin)
      fcn_names = varargin{1};
      rIndex.Fcn = struct(); 
      rIndex.Fcn = mtree_rIndex_fcn(mtreeobj, fcn_names, rIndex.Fcn); 
end


end % finito































