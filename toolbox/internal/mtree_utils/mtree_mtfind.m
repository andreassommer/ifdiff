function r_indices = mtree_mtfind(mtreeobj, type, arg)
% replicate of mtfind for the purposes of type 'string', 'kind'
% Assuming that mtfind is very powerful it is a slow function taking a lot
% of time, this here is faster

% INPUT: type; which column in mtreeobj.T to refer
%   arg: thing to search for (number, e.g, mtreeobj.K.FUNCTION to search
%   for function node) 
% OUTPUT: r_indeces: those r indices where arg matchs in type
% 

cIndex = mtree_cIndex; 
switch type 
    case 'String' 
        
        
    case 'Kind'
        z = (mtreeobj.T(:,cIndex.kindOfNode) == arg)';
        if length(mtreeobj.IX) ~= length(z)
            r_indices = find(z == 1);
        else
            r_indices = find(mtreeobj.IX(1:length(z)).*z == 1);
            
        end
end 



end 