function index = mtree_rIndex_lastNextNodeOfBody(mtreeobj, index, body)
cIndex = mtree_cIndex(); 

% Part 2: LastNextNodeofBody
% if there are nested functions, one needs to know, which next node is the
% last next node in the body before a nested function. I.e. the nextnode of
% the lastnextnodeofbody is a function node .

% define variable 
index.lastNextNodeOfBody = body; 

% prepare while loop 
z = index.lastNextNodeOfBody;
% check if the nextNode is a function node (for a function inside the
% body, or if there exists a nextNode
while z ~= 0 && ~strcmp(mtreeobj.KK{mtreeobj.T(z,cIndex.kindOfNode)},'FUNCTION')
    index.lastNextNodeOfBody = z;
    % calculate next one;  when it is 0 or function node the old one is submitted
    z = mtreeobj.T(index.lastNextNodeOfBody, cIndex.indexNextNode);
end


end 
