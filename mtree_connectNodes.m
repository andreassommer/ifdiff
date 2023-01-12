function mtreeobj = mtree_connectNodes(mtreeobj, from,to,by)
% Get connection between to nodes of mtree
% INPUT: mtreeobj, form: starting index, to: endeing index, by: type w.r.t
% rightchild, leftchild, nextNode; 

cIndex = mtree_cIndex();


mtreeobj.T(from, by) = to; 
mtreeobj.T(to, cIndex.indexParentNode) = from; 
mtreeobj.T(to, cIndex.trueParent) = from; % trueParent is not understood yet


end
