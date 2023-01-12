function index = mtree_rIndex_fcn(mtreeobj, fcn_name, index)
cIndex = mtree_cIndex();

rIndex_mtreeobj = mtree_rIndex(mtreeobj);

if ~isstruct(fcn_name)
    if iscell(fcn_name)
        name = fcn_name;
        fcn_name = struct();
        l = size(name,2);
        for i = 1:l
            fcn_name.(name{1,i}) = name{1,i};
        end
    else
        name = fcn_name;
        fcn_name = struct();
        fcn_name.(name) = name;
    end
end

stringTableIndex = mtreeobj.T(:, cIndex.stringTableIndex);
field_names = fieldnames(fcn_name);
for i = 1:length(fields(fcn_name))
    name = field_names{i};
    index1 = strcmp(mtreeobj.C, fcn_name.(name));
    cIndex_allFcn = find(index1);
    
    index2 = ismember(stringTableIndex, cIndex_allFcn);
    index2 = find(index2)';
    index2 = index2(index2 ~= rIndex_mtreeobj.HEAD.Fname);
    
    
    if isempty(index2)
        continue
    end
    
    % find all functions calls ofq preprocessed i-th function in rhs
    index.(name).Fname = index2;
    
    % get Call node
    index.(name).Call = mtreeobj.T(index.(name).Fname, cIndex.indexParentNode)';
    
    index.(name) = mtree_rIndex_getFunctionArguments(mtreeobj, index.(name), 'Call');
    
    % get expr node
    index.(name).Expr = mtree_findNode(mtreeobj, index.(name).Call, mtreeobj.K.EXPR);
    
    % get equals node
    index.(name).Equals = mtreeobj.T(index.(name).Expr, cIndex.indexLeftchild)';
    
    index.(name).LineBeforeFcnCall_Expr = mtreeobj.T(index.(name).Expr, cIndex.indexParentNode);
    
    index.(name).LineBeforeFcnCall_Equals = mtreeobj.T(index.(name).LineBeforeFcnCall_Expr, cIndex.indexLeftchild);
    
    if index.(name).LineBeforeFcnCall_Equals ~= 0
        index.(name).LineBeforeFcnCall_Function_Index = mtreeobj.T(index.(name).LineBeforeFcnCall_Equals, cIndex.indexLeftchild);
    end
    
    
    
end



end









