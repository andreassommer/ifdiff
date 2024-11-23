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
% For those instances of the function which are not function calls (e.g. being passed as a function handle),
% there can be no arguments, so these entries remain zero.
callIndices = index.(field) ~= 0;
calls = index.(field);

Arguments(callIndices, 1)  = mtreeobj.T(calls(callIndices), cIndex.indexRightchild);
Arguments(~callIndices, 1) = 0;
i = 1;
while any(Arguments(:,i) ~= 0)
    % if a function is called different times with varying numbers of arguments, then you will end up
    % doing mtreeobj.T(0, cIndex.indexNextNode), which crashes. We need to assume that every function
    % call has the same number of arguments.
    Arguments(callIndices,i + 1)   = mtreeobj.T(Arguments(callIndices,i), cIndex.indexNextNode);
    Arguments(~callIndices, i + 1) = 0;
    i = i + 1; 
end

index.([name_prefix, 'Arg']) = Arguments(callIndices,~isnan(Arguments(1,:))); 

% The loop will always add a final zero to the array. If there are no args, we want to keep this, but if there are,
% then the zero should be removed.
if i > 1 
    index.([name_prefix, 'Arg']) = index.([name_prefix, 'Arg'])(:,1:end-1);
end 



end 








