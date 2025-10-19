function s_out = mtree_cIndex()
% struct of 'T' matrix columns of mtree object 'o'


persistent s

if ~isempty(s)
    s_out = s;
    return
end


s.kindOfNode = 1;           % column 1: kind of node
s.indexLeftchild = 2;       % column 2: index of left child
s.indexRightchild = 3;      % column 3: index of right child
s.indexNextNode = 4;        % column 4: index of next node
s.positionNode = 5;         % column 5: position of node
s.sizeOfNode = 6;           % column 6: size of node
s.symbolTableIndex = 7;     % column 7: symbol table index (V)R/
s.stringTableIndex = 8;     % column 8: string table index
s.indexParentNode = 9;      % column 9: index of parent node
s.settingNode = 10;         % column 10: setting node
s.lefttreepos = 11;         % column 11: lefttreepos
s.righttreepos = 12;        % column 12: righttreepos
s.trueParent = 13;          % column 13: true parent
s.righttreeindex = 14;      % column 14: righttreeindex
s.rightfullindex = 15;      % column 15: rightfullindex


s_out = s;


end
