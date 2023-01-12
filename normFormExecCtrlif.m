function obj = normFormExecCtrlif(mtreeobj, index, Arg2, Arg3, Arg4)
% 'o':          mtreeplus object to transfer in normalform
% 'i':          the i-th ctrlif is considered


cIndex = mtree_cIndex(); 

% 'GE' --> greater equal
% 'GT' --> greater
% 'LT' --> smaller
% 'LE' --> smaller equal
% (Vergleichsoperator/ Vergleichszeichen [german])
% comparison_operator = mtreeobj.T(comparision_operator_index, cIndex.kindOfNode); 
[comparison_operator, comparision_operator_index] = mtree_checkForComparisonOperator(mtreeobj, index); 
% depending on the kind of comparison operator, to transformation as it is
% described in normalFormCtrlif 
switch comparison_operator
    
    % '<': a<b <=> a-b>=0
    case mtreeobj.K.LT
        % a<b -> a>=b
        % mtreeobj = changeOperatorCtrlif(mtreeobj,  comparision_operator_index);
        % change operator
        mtreeobj.T(comparision_operator_index, cIndex.kindOfNode) = mtreeobj.K.GE;
        
        % switch 'then' and 'else'
        mtreeobj = normFormExecCtrlif_switchThenAndElsePart(mtreeobj, comparision_operator_index, Arg2, Arg3, Arg4);
        
        % b>=a -> b-a>=0
        if (mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex) ~= 0)
            if (~isequal(mtreeobj.C{mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex)}, '0'))
                mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 0);
            end
        else
            mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 1);
        end
        
        % '>': a>b <=> b-a>=0
    case mtreeobj.K.GT
        % a>b -> a>=b
        mtreeobj.T( comparision_operator_index, cIndex.kindOfNode) = mtreeobj.K.GE;
        % a>=b -> b>=a
        mtreeobj = normFormExecCtrlif_switchChildrenCtrlif(mtreeobj,  comparision_operator_index);
        % switch then and else
        mtreeobj = normFormExecCtrlif_switchThenAndElsePart(mtreeobj, comparision_operator_index, Arg2, Arg3, Arg4);
        % b>=a -> b-a>=0
        if (mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex) ~= 0)
            if (~isequal(mtreeobj.C{mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex)}, '0'))
                mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 0);
            end
        else
            mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 1);
        end
        
        % '<=': a<=b <=> b-a>=0
    case mtreeobj.K.LE
        % a<=b -> a>=b
        mtreeobj.T( comparision_operator_index, cIndex.kindOfNode) = mtreeobj.K.GE;
        % a>=b -> b>=a
        mtreeobj = normFormExecCtrlif_switchChildrenCtrlif(mtreeobj,  comparision_operator_index);
        % b>=a -> b-a>=0
        if (mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex) ~= 0)
            if (~isequal(mtreeobj.C{mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex)}, '0'))
                mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 0);
            end
        else
            mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 1);
        end
        
        % '>=': a>=b <=> a-b>=0
    case mtreeobj.K.GE
        % b>=a -> b-a>=0
        if (mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex) ~= 0)
            if (~isequal(mtreeobj.C{mtreeobj.T(mtreeobj.T( comparision_operator_index, cIndex.indexRightchild), cIndex.stringTableIndex)}, '0'))
                mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 0);
            end
        else
            mtreeobj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj,  comparision_operator_index, 1);
        end
    otherwise       % not one of the four above -> error (for now)
        disp('Error. "If" statement does not include relation of the form "<", ">", "<=" or ">=".');
end

% output
obj = mtreeobj;
end