function index = mtree_rIndex_If(mtreeobj, index)
cIndex = mtree_cIndex();


% Find all if and their arguments etc.


% search for all if in the mtree
z_subtree = mtreeobj.mtfind('Kind', 'IF');
z = z_subtree.indices; 
if ~isempty(z)
    index.IF = z;
    index.IFHEAD = mtreeobj.T(index.IF, cIndex.indexLeftchild)';
    % condition (switching function)
    index.cond = mtreeobj.T(index.IFHEAD, cIndex.indexLeftchild)';
    index.else = mtreeobj.T(index.IFHEAD, cIndex.indexNextNode)';
end 

end
