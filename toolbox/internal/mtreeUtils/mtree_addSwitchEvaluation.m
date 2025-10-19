function [mtreeobj, operatorKind] = mtree_addSwitchEvaluation(mtreeobj, from, condition)
% [mtreeobj, operatorKind] = mtree_addSwitchEvaluation(mtreeobj, from, condition)
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
% ´operatorKind´            The comparison operator the switch condition
%                           contained (<,>,<=,>=).


% Determine the operator involved in the switch condition
[operatorKind, rIndexOperator] = mtree_getFirstComparisonOperator(mtreeobj, condition);

if ~ismember(operatorKind, [mtreeobj.K.GE, mtreeobj.K.GT, mtreeobj.K.LT, mtreeobj.K.LE])
    % operator is none of the allowed types
    error( ...
        config.errors.infeasible_if_condition, ...
        '"If" statement does not include on of the comparisons <, >, <=, >=.');
end

cIndex = mtree_cIndex();
mtreeobj = mtree_connectNodes(mtreeobj, from, condition, cIndex.indexRightchild);

% Transform comparison into normal form (i.e. <expr> >= 0)
% '<=': a<=b <=> b-a>=0
% '>': a>b <=> not b-a>=0
% '<': a<b <=> not a-b>=0
% '>=': a>=b <=> a-b>=0

% Switch a and b first if necessary.
if operatorKind == mtreeobj.K.LE || operatorKind == mtreeobj.K.GT
    mtreeobj = mtree_switchLeftRightChildren(mtreeobj, rIndexOperator);
end

% Replace comparison operator by minus.
mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj, rIndexOperator);

% preprocess_setUpCtrlif(...) takes care of the negation if necessary.
end
