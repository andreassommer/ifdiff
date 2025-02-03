function [mtreeobj, comparison_operator] = mtree_addSwitchEvaluation(mtreeobj, from, condition)
% [mtreeobj, comparison_operator] = mtree_addSwitchEvaluation(mtreeobj, from, condition)
% 
% Takes the condition at rIndex ´condition´, copies it to ´from´ and
% converts it into a switching function evaluation.
% For example, a >= b is converted into a - b.
%
%
% INPUT:
% ´mtreeobj´                mtree
% ´from´                    rIndex at which to add the switch evaluation.
% ´condition´               rIndex of switch condition.
%
%
% OUTPUT:
% ´mtreeobj´                Edited mtree.
% ´comparison_operator´     The comparison operator the switch condition
%                           contained (<,>,<=,>=).


% Determine the operator involved in the switch condition
[comparison_operator, comparison_operator_index] = mtree_getFirstComparisonOperator(mtreeobj, condition);

cIndex = mtree_cIndex();
mtreeobj = mtree_connectNodes(mtreeobj, from, condition, cIndex.indexRightchild);

% exchange comparison by minus and switch a and b if normal form indicates so
switch comparison_operator

    % '<': a<b <=> not a-b>=0
    case mtreeobj.K.LT
        % a<b -> a-b (replace operator by minus)
        indexRightChild = mtreeobj.T( comparison_operator_index, cIndex.indexRightchild);
        stringTableIndexRightChild = mtreeobj.T(indexRightChild, cIndex.stringTableIndex);

        if (stringTableIndexRightChild ~= 0)
            % Right child has a string. Include parantheses.
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 0);
        else
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 1);
        end
        % That's it for now. 
        % preprocess_setUpCtrlif(...) takes care of the negation operator.


    % '>=': a>=b <=> a-b>=0
    case mtreeobj.K.GE
        % a>=b -> a-b
        indexRightChild = mtreeobj.T( comparison_operator_index, cIndex.indexRightchild);
        stringTableIndexRightChild = mtreeobj.T(indexRightChild, cIndex.stringTableIndex);
        if ( stringTableIndexRightChild ~= 0)
            % Right child has a string. Include parantheses.
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 0);
        else
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 1);
        end
    

    % '<=': a<=b <=> b-a>=0
    case mtreeobj.K.LE
        % a<=b -> b<=a
        mtreeobj = mtree_switchLeftRightChildren(mtreeobj,  comparison_operator_index);

        % b<=a -> b-a
        indexRightChild = mtreeobj.T( comparison_operator_index, cIndex.indexRightchild);
        stringTableIndexRightChild = mtreeobj.T(indexRightChild, cIndex.stringTableIndex);
        if (stringTableIndexRightChild ~= 0)
            % Right child has a string. Include parantheses.
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 0);
        else
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 1);
        end
      

    % '>': a>b <=> not b-a>=0
    case mtreeobj.K.GT
        % a>=b -> b>=a
        mtreeobj = mtree_switchLeftRightChildren(mtreeobj,  comparison_operator_index);
        
        % b>=a -> b-a
        indexRightChild = mtreeobj.T( comparison_operator_index, cIndex.indexRightchild);
        stringTableIndexRightChild = mtreeobj.T(indexRightChild, cIndex.stringTableIndex);

        if (stringTableIndexRightChild ~= 0)
            % Right child has a string. Include parantheses.
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 0);
        else
            mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj,  comparison_operator_index, 1);
        end
        % Regarding the negation operator, see above.
        

    otherwise
        % operator is none of the allowed types
        error(config.errors.infeasible_if_condition, ...
              '"If" statement does not include on of the comparisons <, >, <=, >=.');
end


end
