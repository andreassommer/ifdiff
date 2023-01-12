function output = mtree_findBeginOfLine(mtreeobj, start_node, node_index_to_find, varargin)
% Function to either find a expr node are any other beginning of an line
% for example if, while etc.

cIndex = mtree_cIndex();

body_node = mtreeobj.T(1, cIndex.indexRightchild);
% stop searching for expr when found one of highest_possible_level

% preallocation
chunk = 20;
highest_possible_level = [body_node; zeros(chunk - 1,1)]; 


% find all next nodes after body until end of the function 
i = 2;
new_nextNode = mtreeobj.T(body_node, cIndex.indexNextNode);
while new_nextNode ~= 0
    highest_possible_level(i,1) = new_nextNode; 
    new_nextNode = mtreeobj.T(new_nextNode, cIndex.indexNextNode);
    i = i + 1;
    if i > length(highest_possible_level)
        u = highest_possible_level; 
        highest_possible_level = [u; zeros(chunk, 1)]; 
    end 
end

highest_possible_level = highest_possible_level(1:i-1,1); 



% preallocation
output = zeros(1,length(start_node));

for i = 1:length(start_node)
    z = mtreeobj.T(start_node(i), cIndex.indexParentNode)';
    while mtreeobj.T(z, cIndex.kindOfNode) ~= node_index_to_find
        z = mtreeobj.T(z, cIndex.indexParentNode)';
        
        
        if any(z == highest_possible_level, 'all')
            break
        end
        
        
        % The functions assumes that there always exits a expr node (as last node). When
        % one does not search for a expr not, then the computation is
        % canceled as soon as an expr node is reached
        
        if mtreeobj.T(z, cIndex.kindOfNode) == mtreeobj.K.FUNCTION
            output = {};
            return % cancel computation with empty output, by this one later can
            % recognize, whether the node that was search for exists or not
            % deprecated
        end
        
        % assign output node
    end
    output(i) = z;
    
end















