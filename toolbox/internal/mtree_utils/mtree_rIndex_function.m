function index_output = mtree_rIndex_function(mtreeobj, rIndex_head, index_input, fname)
% get the row indices of (fname) function.
% The (possible) fields to the struct index_output are:
% (fname): the ID node with the function name
% (fname_Fname): same as fname
% (fname_call): the call node, usually the parent of the ID node
% (fname_Equals): the equals node that assigns (fname_call) to some variable
% (fname_Out): the left-hand side of the assignment statement fname_Equals
% (fname_expr): the expr node of the assignment statement, parent of fname_Equals
% (fname_Arg): the arguments to each function call
% All these fields are row vectors with one entry for each occurrence of fname, while fname_Arg is a matrix.
% The ways these fields can be set depending on how fname is used:
% case 1. fname is used in a top-level assignment statement, e.g. `var = fname(arg1, arg2)`. All fields in index_output
%     have a nonzero row index in the corresponding entry.
% case 2. fname is called as a function, but this call is not the RHS of an assignment statement. For example,
%     `if fname(arg1, arg2) ...`. In this case,
%     fname_Equals, fname_Out, and fname_expr will be zero at the corresponding index.
% case 3. fname is passed as a function handle. Only fname and Fname are nonzero, all other fields are zero.

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
if isfield(rIndex_head, 'Fname')
    % if the function itself is named the same as the function we are investigating, skip this occurrence of fname
    z = z(z ~= rIndex_head.Fname);
end

n = length(z);
if ~isempty(z)
    index.(fname) = z; 
    index.(Fname) = z; % deprecated, use .(fname)

    % For each use of fname, check its parent, then the parent's parent, etc. to determine if it is in an assignment
    % statement
    callNodes                = mtreeobj.T(index.(fname), cIndex.indexParentNode);
    % assignedCalls stores which instances have not yet been disqualified
    calls                    = mtreeobj.T(callNodes, cIndex.kindOfNode) == mtreeobj.K.CALL;
    assignments              = calls;
    equalsNodes              = zeros(n, 1);
    equalsNodes(assignments) = mtreeobj.T(callNodes(assignments), cIndex.indexParentNode);
    assignments(assignments) = mtreeobj.T(equalsNodes(assignments), cIndex.kindOfNode) == mtreeobj.K.EQUALS;
    exprNodes                = zeros(n, 1);
    exprNodes(assignments)   = mtreeobj.T(equalsNodes(assignments), cIndex.indexParentNode);
    assignments(assignments) = mtreeobj.T(exprNodes(assignments), cIndex.kindOfNode) == mtreeobj.K.EXPR;

    callNodes(~calls)         = 0;
    equalsNodes(~assignments) = 0;
    exprNodes(~assignments)   = 0;
    outNodes                  = zeros(n, 1);
    outNodes(assignments)     = mtreeobj.T(equalsNodes(assignments), cIndex.indexLeftchild);

    index.(call)   = callNodes';
    index.(Equals) = equalsNodes';
    index.(expr)   = exprNodes';
    index.(Out)    = outNodes';
    index = mtree_rIndex_getFunctionArguments(mtreeobj, index, call, [fname, '_']); 
end

index_output = index; 
end 





