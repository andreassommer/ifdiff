function [Array1, Array2] = deleteUnusedParameters_bltStrArr(mtreeobj)
% builts two arrays: one is a list of all indices of all ID nodes in the
% second array, which include all strings that occur in the mtree
% object, but unique
% 'o': given mtreeplus object
% 'frstArr': an array that contains the node number of the ID nodes and
% the corresponding index of Array1
% 'scndArr': contains all strings (uniquely) that appear in ID nodes

cIndex = mtree_cIndex(); 

% get a list of all indices of all ID nodes
%rIndex_ID2 = mtreeobj.mtf ind('Kind', 'ID').indices;

rIndex_ID = mtree_mtfind(mtreeobj, 'Kind', mtreeobj.K.ID); 


idCnt = length(rIndex_ID);

% preallocate memory 
% scndArr
Array1 = zeros(idCnt, 2);
Array2 = cell.empty(idCnt, 0);

% number of Array two
nArray2 = 0;

% walk through the list and check if the corresponding string is
% already in Array2
for i = 1:idCnt
    
    % getting the current string
    hlpChr = mtreeobj.C{mtreeobj.T(rIndex_ID(i), cIndex.stringTableIndex)};
    
    % checking if the string appeared previously
    hlpIdx = find(ismember(Array2, hlpChr));
    if ~isempty(hlpIdx)
        Array1(i, :) = [rIndex_ID(i), hlpIdx];
        % if it has not appeared yet, add the character to Array2
    else
        nArray2 = nArray2 + 1;
        Array2{nArray2} = hlpChr;
        Array1(i, :) = [rIndex_ID(i), nArray2];
    end
    
end
Array2 = Array2(1:nArray2);
end