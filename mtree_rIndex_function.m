function index_output = mtree_rIndex_function(mtreeobj, index_input, fname)
% get the row indices of (fname) function 
% when a fcn call looks like a = func(b,c,d) 
% the functions searchs for the corresponding nodes 
% fails if function call has no expr node (e.g. if it is in the function head) 

config = makeConfig(); 

cIndex = mtree_cIndex(); 

expr   = [fname, config.mtree_rIndex_function.Suffix_expr]; 
call   = [fname, config.mtree_rIndex_function.Suffix_call]; 
Equals = [fname, config.mtree_rIndex_function.Suffix_equals]; 
Out    = [fname, config.mtree_rIndex_function.Suffix_out]; 
Fname  = [fname, config.mtree_rIndex_function.Suffix_fname]; 

index = index_input; 

% search for (fname)
z_subtree = mtreeobj.mtfind('String', fname);
z = z_subtree.indices; 
if ~isempty(z)
    index.(fname) = z; 
    
    index.(expr) = mtree_findNode(mtreeobj, index.(fname), mtreeobj.K.EXPR);
    % expr does not exist it is empty
    if isempty(index.(expr)) 
        % no expr node => no output do deliver
        index_output = index_input; 
        return
    end 
    
    index.(Fname) = z; % depreceted, use .(fname)
    index.(call) = mtreeobj.T(index.(fname), cIndex.indexParentNode)';
    index.(Equals) = mtreeobj.T(index.(call), cIndex.indexParentNode)';
    
    % 'Out' = Output
    index.(Out) = mtreeobj.T(index.(Equals), cIndex.indexLeftchild)';
    index = mtree_rIndex_getFunctionArguments(mtreeobj, index, call, [fname, '_']); 
    
    index.LineBeforeFcnCall_Expr = mtreeobj.T(index.(expr), cIndex.indexParentNode);   
    index.LineBeforeFcnCall_Equals = mtreeobj.T(index.LineBeforeFcnCall_Expr, cIndex.indexLeftchild);
end

index_output = index; 
end 





