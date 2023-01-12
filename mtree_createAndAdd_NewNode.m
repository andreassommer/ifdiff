function [mtreeobj, rIndex_new_row] = mtree_createAndAdd_NewNode(mtreeobj, varargin) 
% create and add new nodes to a mtree. 
% 
% INPUT: 
% mtreeobj  --> mtree object of rhs function 
% from      --> start node. 
% from_type --> The start node gets the new line als choosen in from_type; choose from: 
%               cIndex.indexLeftchild, cIndex.indexRightchild, cIndex.indexNextNode
% new_node  --> variable: {mtreeobj.K.ID, 'new_variable_name_here'}
%               integer:  {mtreeobj.K.INT, '0'}
%               other:    mtreeobj.K.EXPR, mtreeobj.K.EQUALS, etc.
% to        --> if one wants the new node between to lines, one can
%               determine, what childs the new node has. When to == 0; the
%               connection will be ignored
% to_type   --> type for connection to (rightchild, leftchild, nextnode)
% 
% OUTPUT: 
%  mtreeobj       --> mtreeobj with new node
%  rIndex_new_row --> row Index of the new node. 
% 
% 
% 
% Example: 
%
% [mtreeobj, new_node_index] = mtree_createAndAdd_NewNode(mtreeobj, ...
%     10, ...                                                               % from
%     cIndex.indexRightchild, ...                                            % from_type
%     mtreeobj.K.EXPR, ...                                                   % new_node
%     [11, 12, 13], ...                                                      % to
%     [cIndex.indexLeftchild, cIndex.indexRightchild, cIndex.indexNextNode]; % to_type
%
% Can be read as follows: 
% Row 10 of the dumptree (or rawdump) gets a new rightchild, an expression
% node (i.e. a new line). The new line has line 11 as leftchild, line 12
% as rightchild and line 13 as nextnode. 
% 
% 
% 
%
% The mtree has 15 porperties, but of those only kindOfNode, indexLeftchild, 
% indexRightchild, indexNextNode, sizeOfNode, stringTableIndex,
% indexParentNode are understood from the author of this function. 
% 
% I.e. this functions works with the assumption, that only these have to be
% considered. 
% kindOfNode, indexLeftchild, indexRightchild, indexNextNode and a char string 
% for a new variable are set by user, the others can be derived from the
% given information. 
%
% all other cIndex types are set by default as 0. 


% notation:
% cIndex -> column index; refers to a property type
cIndex = mtree_cIndex(); 

% assign input 
from = varargin{1}; 
from_type = varargin{2}; 
kind = varargin{3}; 



% check whether to add variable/integer or other
if length(kind) == 1
    % check input
    % be careful: For adding an new EXPR node, use function mtree_addNewExprNode
    % no warning for user here, because mtree_addNewExprNode uses
    % mtree_createAndAdd_NewNode as well. 

    newNode = mtree_createMtreeNode('kindOfNode', kind);
else % add new variable
    % if variable, then kind is 2-dim array
    kindOfNode = kind{1}; 
    str = kind{2}; 
    
    % add string of new variable to string table index of the mtree
    index_new_node = length(mtreeobj.C) + 1;
    mtreeobj.C{index_new_node} = str;
    
    % kindOfNode; ID if variable, INT for integer
    % sizOfNode: length of the character string
    % stringtableindex: position of the string in mtreeobj.C (array of all variables)
    newNode = mtree_createMtreeNode('kindOfNode',  kindOfNode, ...
                              'sizeOfNode', length(str), ...
                        'stringTableIndex', index_new_node); 
end

% new row index
rIndex_new_row = length(mtreeobj.IX) + 1; 

% check if there is any input for to/to_type.
if nargin >= 5
    to = varargin{4};
    to_type = varargin{5};
    
    if to ~= 0 % caution Remark: extend compability with multiple values in to 
        
        % if t0 == 0 alignment will fail, but that is not a problem. When
        % there are no nodes to connect to, then a connection is not
        % required
        
        % newNode gets the new child (left, right or next)
        newNode(1,to_type) = to;
        
        mtreeobj.T(to, cIndex.indexParentNode) = rIndex_new_row;
    end
end

% get the connection from the start node to the new node
mtreeobj.T(from, from_type) = rIndex_new_row;

% assign new Node to the mtree
mtreeobj.T(rIndex_new_row, :) = newNode; 

mtreeobj.T(rIndex_new_row, cIndex.indexParentNode) = from; 

% extend the active set of the mtree
mtreeobj.IX = [mtreeobj.IX, 1];

% adjust the number of nodes of the mtree
mtreeobj.n = mtreeobj.n + 1; 

% adjust the sum of IX
mtreeobj.m = mtreeobj.m + 1; 
end 












