classdef MtreeHelperFunctionCallInfo
    %MTREEFUNCTIONCALLINFO  For an mtree, store the row indices relevant to helper function calls
    
    properties (Access=public)
        functionIndex
        rIndexExpr
        rIndexEquals
        rIndexCall
        rIndexFname
        rIndexArgs
    end
    properties (SetAccess=private)
        functionIndexToIdxMap = {};
    end
    methods
        % Constructor
        function obj = MtreeHelperFunctionCallInfo()
            
        end
        function index = functionIndexToIdxRIndex(this, functionIndex)
            index = find(functionIndex == this.functionIndex);
        end
    end
end

