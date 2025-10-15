function node = mtree_createMtreeNode(varargin)
% Function for mtree manipulation; 
% Mtree object save properties in matrix (see e.g. mtreeobj.T;
%                       here mtreeobj is a random mtree object)
% The mtree can be manipulated by new lines in the matrix. 
% This functions can create new lines 
% 
% 
% INPUT: varargin -> select which characteristic of the new node one want
%                    to set. Choose from  
%                         kindOfNode, ...
%                         indexLeftchild, ...
%                         indexRightchild, ...
%                         indexNextNode, ...
%                         positionNode, ...
%                         sizeOfNode, ...
%                         symbolTableIndex, ...
%                         stringTableIndex,...
%                         indexParentNode,  ...
%                         settingNode,  ...
%                         lefttreepos, ...
%                         righttreepos,  ...
%                         trueParent,  ...
%                         righttreeindex, ...
%                         rightfullindex. 
%                   
% 
% OUTPUT:
%  'node': Matrix vector size 1x15 with 
%       column 1:  kind of node
%       column 2:  index of left child
%       column 3:  index of right child
%       column 4:  index of next node
%       column 5:  position of node
%       column 6:  size of node
%       column 7:  symbol table index (V)R/
%       column 8:  string table index
%       column 9:  index of parent node
%       column 10: setting node
%       column 11: lefttreepos
%       column 12: righttreepos
%       column 13: true parent
%       column 14: righttreeindex
%       column 15: rightfullindex
% (Mai 2020; extracted from matlab file mtree.m) 
% 
% Those characteristics who are not mentioned get as
%                   default the value 0; 


    % assign value (by input arguments or by default 0) 
    kindOfNode        = getValueOrDefault('kindOfNode'); 
    indexLeftchild    = getValueOrDefault('indexLeftchild'); 
    indexRightchild   = getValueOrDefault('indexRightchild'); 
    indexNextNode     = getValueOrDefault('indexNextNode'); 
    positionNode      = getValueOrDefault('positionNode'); 
    sizeOfNode        = getValueOrDefault('sizeOfNode'); 
    symbolTableIndex  = getValueOrDefault('symbolTableIndex'); 
    stringTableIndex  = getValueOrDefault('stringTableIndex');  
    indexParentNode   = getValueOrDefault('indexParentNode'); 
    settingNode       = getValueOrDefault('settingNode'); 
    lefttreepos       = getValueOrDefault('lefttreepos');  
    righttreepos      = getValueOrDefault('righttreepos'); 
    trueParent        = getValueOrDefault('trueParent'); 
    righttreeindex    = getValueOrDefault('righttreeindex'); 
    rightfullindex    = getValueOrDefault('rightfullindex'); 


    % assemble output; a vector that can be added to mtreeobj.T
    % has always size 1x15
    node = [kindOfNode, ...
            indexLeftchild, ...
            indexRightchild, ...
            indexNextNode, ...
            positionNode, ...
            sizeOfNode, ...
            symbolTableIndex, ...
            stringTableIndex,...
            indexParentNode,  ...
            settingNode,  ...
            lefttreepos, ...
            righttreepos,  ...
            trueParent,  ...
            righttreeindex, ...
            rightfullindex]; 
    return; % endfunction 
    
    
    % helper function; check if string 'name' is mentioned in varargin and assign
    % value (from input by user); 
    % if not mentioned from user set as default value 0; 
    function n = getValueOrDefault(name)
        if olHasOption(varargin, name)
            % assgin value as given through input
            n = olGetOption(varargin, name);
        else % default value 
            n = 0;
        end
    end 
        
        
end 









