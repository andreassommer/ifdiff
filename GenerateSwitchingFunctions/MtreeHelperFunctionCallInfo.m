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
        activeIndex = [];
    end
    methods
        % Constructor
        function obj = MtreeHelperFunctionCallInfo(functionIndex)
            if nargin == 0
                return
            end

            obj.functionIndex = functionIndex;
            obj.activeIndex = functionIndex;
        end

        function index = functionIndexToActiveIndex(this, functionIndex)
            index = find(functionIndex == this.functionIndex);
        end
       

        function this = setActiveIndex(this, functionIndex)
            this.activeIndex = this.functionIndexToActiveIndex(functionIndex);
        end
    end

    % Getters
    methods
        function rIndex = get.rIndexExpr(this)
            if isempty(this.activeIndex)
                rIndex = this.rIndexExpr;
            else
                rIndex = this.rIndexExpr(this.activeIndex);
            end
        end

        function rIndex = get.rIndexEquals(this)
            if isempty(this.activeIndex)
                rIndex = this.rIndexEquals;
            else
                rIndex = this.rIndexEquals(this.activeIndex);
            end
        end

        function rIndex = get.rIndexCall(this)
            if isempty(this.activeIndex)
                rIndex = this.rIndexCall;
            else
                rIndex = this.rIndexCall(this.activeIndex);
            end
        end

        function rIndex = get.rIndexFname(this)
            if isempty(this.activeIndex)
                rIndex = this.rIndexFname;
            else
                rIndex = this.rIndexFname(this.activeIndex);
            end
        end

        function rIndex = get.rIndexArgs(this)
            if isempty(this.activeIndex)
                rIndex = this.rIndexArgs;
            else
                rIndex = this.rIndexArgs(this.activeIndex, :);
            end
        end
    end
end

