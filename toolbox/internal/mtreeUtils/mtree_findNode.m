function output = mtree_findNode(mtreeobj, start_node, kind_of_node_to_find, varargin)
% check whether parent node is of kind 'kind_of_node_to_find' as long as
% one reachs either at kind of node that is searched for or return empty
% set when function is reached (i.e. the node searched for does not exist
%
% INPUT: start_node: first point that the parent node is checked
% kind_of_node_to_find: element of mtreeobj.K (e.g. mtreeobj.K.EXPR when
% one searchs for expression node)
cIndex = mtree_cIndex();


% preallocate memory
output = zeros(1,length(start_node));

for i = 1:length(start_node)
    % get new parent node
    z = mtreeobj.T(start_node(i), cIndex.indexParentNode)';
    while mtreeobj.T(z, cIndex.kindOfNode) ~= kind_of_node_to_find
        % get new parent node
        z = mtreeobj.T(z, cIndex.indexParentNode)';
        
        if mtreeobj.T(z, cIndex.kindOfNode) == mtreeobj.K.FUNCTION
            output = {};
            return % cancel computation with empty output, by this one later can
            % recognize, whether the node that was search for exists or not
        end
    end
    output(i) = z;
    
end


end 
