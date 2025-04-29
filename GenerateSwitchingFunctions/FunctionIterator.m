classdef FunctionIterator
    %FUNCTIONITERATOR   Trace function calls through the mtrees in which they appeared in by processing the function index.


    properties (Access=public)
        functionIndexArray = []
        functionIndex = []
        idxMtreeCallerOriginal = []
        idxMtreeCallerExport = []
        idxMtreeCallOriginal = []
        idxMtreeCallExport = []
        stop = false
        new = false
    end

    properties (SetAccess=private)
        functionData = []
        idx = 1
        functionIndexToIdxMtreeExportMap = [];
    end

    methods
        function obj = FunctionIterator(functionData)
            % Constructor - Takes an object of class PreproccesedFunctionData

            % RHS has function index 0 and gets export ID 1
            obj.functionIndexToIdxMtreeExportMap = HashMap(@(key) numericJoin(key, '-'));
            obj.functionIndexToIdxMtreeExportMap.set(0, 1)

            if nargin == 0
                return
            end

            obj.functionData = functionData;
        end

        function this = reset(this, functionIndexArray)
            this.functionIndexArray = functionIndexArray;
            this.functionIndex = [];
            this.idx = 1;
            this.idxMtreeCallerOriginal = [];
            this.idxMtreeCallerExport = [];
            this.idxMtreeCallOriginal = [];
            this.idxMtreeCallExport = [];
        end

        function this = next(this)
            % Clear flags
            this.stop = false;
            this.new = false;

            % Update the caller to the callee of the previous iteration
            if isempty(this.idxMtreeCallOriginal)
                % If we have not seen a function call yet, then we are in the RHS
                this.idxMtreeCallerOriginal = 1;
                this.idxMtreeCallerExport = 1;
            else
                this.idxMtreeCallerOriginal = this.idxMtreeCallOriginal;
                this.idxMtreeCallerExport = this.idxMtreeCallExport;
            end

            % Stop Iteration because there are no further function calls
            if isequal(this.functionIndexArray, 0) || this.idx > length(this.functionIndexArray)
                this.stop = true;
                return
            end

            functionCallIndex = this.functionIndexArray(1:this.idx);
            % Find out which function corresponds to the function index in the caller mtree
            this.idxMtreeCallOriginal = this.functionData.getIdxMtreeFromFunctionCall(this.idxMtreeCallerOriginal, functionCallIndex(end));

            % Check if this function call sequence has already been exported into a helper function
            this.idxMtreeCallExport = this.functionIndexToIdxMtreeExportMap.get(functionCallIndex);

            % If not then assign a new export ID to this helper function
            if isempty(this.idxMtreeCallExport)
                this.new = true;
                % ID is generated sequentially
                this.idxMtreeCallExport = this.functionIndexToIdxMtreeExportMap.size + 1;
                this.functionIndexToIdxMtreeExportMap.set(functionCallIndex, this.idxMtreeCallExport);
            end

            this.functionIndex = this.functionIndexArray(this.idx);
            this.idx = this.idx + 1;
        end
    end
end
