function mtree = replaceCtrlifByTrueOrFalse(mtree, rIndexEquals, rIndexArg)
%mtree = REPLACECTRLIFBYTRUEORFALSE(mtree, rIndexEquals, rIndexArg)
%
%Replace a ctrlif call with its true or false part.
%
%INPUT:
%   mtree - Mtree containing the ctrlif to be replaced.
%       mtreeplus
%
%   rIndexEquals - Row index of the EQUALS node assigning the output of the ctrlif.
%       positive integer
%
%   rIndexArg - Row index of the ctrlif argument which should replace the call.
%   Note: The 2nd argument of a ctrlif call contains the true part and the 3rd contains the false part.
%       positive integer
%
%OUTPUT:
%   mtree - Modified mtree with the ctrlif call replaced.
%       mtreeplus

cIndex = mtree_cIndex();

mtree = mtree_connectNodes(...
    mtree, ...
    rIndexEquals, ...
    rIndexArg, ...
    cIndex.indexRightchild ...
    );
end
