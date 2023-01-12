function index = mtree_rIndex_getFunctionArguments(mtreeobj, index, field, varargin) 
% Function to get all the arguments of a function call, as long as they
% exist
% INPUT: mtreeobj
%        index: Call of the Function (leftchild is function name,
%        rightchild is first argument) 
%        field: call node
cIndex = mtree_cIndex(); 

if ~isempty(varargin) 
    name_prefix = varargin{1};
else 
    name_prefix = []; 
end 

% index.([name_prefix, 'Arg1']) = mtreeobj.T(index.(field), cIndex.indexRightchild);
% i = 1;
% while index.([name_prefix, 'Arg', num2str(i)]) ~= 0
%     index.([name_prefix, 'Arg', num2str(i + 1)]) = mtreeobj.T(index.([name_prefix, 'Arg', num2str(i)]), cIndex.indexNextNode);
%     i = i + 1; 
% end
% 
% % keep Arg1 (when it does not exist, Arg1 is zero
% if i > 1 
%     index = rmfield(index, [name_prefix, 'Arg', num2str(i)]);
%     index.([name_prefix, 'lstArg']) = index.([name_prefix, 'Arg', num2str(i - 1)]); 
% end 


% preallocate Arg
chunk = 10; 
Arguments = NaN(length(index.(field)),chunk); 

Arguments(:,1) = mtreeobj.T(index.(field), cIndex.indexRightchild);
i = 1;
while Arguments(1,i) ~= 0
    Arguments(:,i + 1) = mtreeobj.T(Arguments(:,i), cIndex.indexNextNode);
    i = i + 1; 
end

index.([name_prefix, 'Arg']) = Arguments(:,~isnan(Arguments(1,:))); 

% keep Arg1 (when it does not exist, Arg1 is zero
if i > 1 
    index.([name_prefix, 'Arg']) = index.([name_prefix, 'Arg'])(:,1:end-1);
end 



end 








