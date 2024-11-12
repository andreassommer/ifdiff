classdef MtreeFunctionCallInfo
    %MTREEFUNCTIONCALLINFO  For an mtree, store the row indices relevant to a function call
    
    properties (Access=public)
        functionIndex
        rIndexExpr
        rIndexCall
        rIndexName
        rIndexArg
    end
    methods
        function index = functionIndexToIndex(functionIndex)
            index = find(functionIndex == this.functionIndex);
        end
    end
end

