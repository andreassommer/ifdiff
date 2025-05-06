classdef FunctionIterator
    %this = FUNCTIONITERATOR(functionData)
    %
    %Use a list of function indices to iterate over mtrees based on the functions that were called.
    %Also responsible for determining whether or not a helper function encountered during iteration should be exported.
    %
    %INPUT:
    %   functionData - Data related to preprocessed functions. Necessary to determine function calls in an mtree.
    %       PreprocessedFunctionData
    %
    %OUPUT:
    %   this - New iterator configured for iteration on the functions stored in the functionData.
    %   Note: Use the resetIteration function to actually set an iterable function index and begin iteration.
    %       FunctionIterator

    properties (SetAccess=private)
        % Full function index call sequence.
        functionIndexArray = []
        % Function index of the function that was considered the callee in the last iteration.
        functionIndex = []
        % FunctionData index of the unmodified caller mtree.
        idxMtreeCallerOriginal = []
        % Export index of the modified caller mtree assigned during switching function creation.
        idxMtreeCallerExport = []
        % FunctionData index of the unmodified mtree of the function that was called in the caller mtree.
        idxMtreeCallOriginal = []
        % Export index of the modified mtree of the function that was called in the caller mtree.
        idxMtreeCallExport = []
        % Flag indicating whether there are further function calls to iterate over.
        stop = false
        % Flag indicating whether the callee function in the last iteration should be exported or not.
        new = false
    end

    properties (Access=private)
        functionData = []
        functionIndexToIdxMtreeExportMap = []
        idx = 1
    end

    methods
        % Constructor
        function this = FunctionIterator(functionData)
            % RHS has function index 0 and gets export ID 1
            this.functionIndexToIdxMtreeExportMap = HashMap(@(key) arrayStrJoin(key, '-', '%u'));
            this.functionIndexToIdxMtreeExportMap.set(0, 1)

            if nargin == 0
                return
            end

            this.functionData = functionData;
        end

        function this = resetIteration(this, functionIndexArray)
            %this = this.RESETITERATION(functionIndexArray)
            %
            %Start a new iteration, but keep the information related to exported helper functions.
            %
            %INPUT:
            %   functionIndexArray - Sequence of helper function calls expressed as function indices.
            %       1xN array of positive integers
            %
            %OUTPUT:
            %   this - New iterator ready to begin a new iteration.
            %       functionIterator

            this.functionIndexArray = functionIndexArray;
            this.functionIndex = [];
            this.idxMtreeCallerOriginal = [];
            this.idxMtreeCallerExport = [];
            this.idxMtreeCallOriginal = [];
            this.idxMtreeCallExport = [];
            this.idx = 1;
        end

        function this = next(this)
            %this = this.NEXT()
            %
            %Move the iterator forward based on the mtree index of the previous iteration and the current function index.
            %
            %It is important that we store both the original and export mtree index for caller and callee in each iteration,
            %since this information is required to adjust function calls during switching function creation.
            %
            %INPUT:
            %   this.idxMtreeCall[Original|Export] - Index of the callee mtree from the previous iteration.
            %   Will be set as the caller of this iteration. If empty, assume that the caller is the RHS (index 1).
            %       positive integer
            %
            %   this.functionIndexArray - Used to determine which function is called in this iteration.
            %       1xN array of positive integers
            %
            %   this.idx - Determines the current function index for this iteration.
            %       positive integer
            %
            %OUTPUT:
            %   this.idxMtreeCaller[Original|Export] - Index of the mtree considered to be the caller of this iteration.
            %       positive integer
            %
            %   this.idxMtreeCall[Original|Export] - Index of the mtree considered to be the callee of this iteration.
            %       positive integer
            %
            %   this.functionIndex - Function index of the callee function in this iteration.
            %       positive integer
            %
            %   this.stop - Flag indicating whether or not this iteration was the final one (i.e. no more function calls).
            %       logical
            %
            %   this.new - Flag indicating whether or not the callee function in this iteration has a call sequence,
            %   that was never encountered before. If so, then the called helper function should be exported.
            %       logical

            % Clear flags
            this.stop = false;
            this.new = false;

            % Update the caller mtree index.
            if isempty(this.idxMtreeCallOriginal)
                % If we have not seen a function call yet, then assume we are in the RHS.
                this.idxMtreeCallerOriginal = 1;
                this.idxMtreeCallerExport = 1;
            else
                % Otherwise set the callee of the previous iteration as the new caller.
                this.idxMtreeCallerOriginal = this.idxMtreeCallOriginal;
                this.idxMtreeCallerExport = this.idxMtreeCallExport;
            end

            % Stop Iteration because there are no further function calls.
            % Note: A function index of zero indicates that there are no function calls apart from the inital RHS call.
            if isequal(this.functionIndexArray, 0) || this.idx > length(this.functionIndexArray)
                this.stop = true;
                return
            end

            % Find out which function corresponds to the current function index in the caller mtree.
            this.idxMtreeCallOriginal = this.functionData.getIdxMtreeFromFunctionCall( ...
                this.idxMtreeCallerOriginal, ...
                this.functionIndexArray(this.idx) ...
                );

            % Check if the current function call sequence has already been seen and exported into a helper function.
            functionCallSeq = this.functionIndexArray(1:this.idx);
            this.idxMtreeCallExport = this.functionIndexToIdxMtreeExportMap.get(functionCallSeq);

            % If not, then assign a new export ID to this function call sequence/helper function.
            if isempty(this.idxMtreeCallExport)
                this.new = true;
                % ID is generated sequentially by order of appearance.
                this.idxMtreeCallExport = this.functionIndexToIdxMtreeExportMap.size + 1;
                this.functionIndexToIdxMtreeExportMap.set(functionCallSeq, this.idxMtreeCallExport);
            end

            this.functionIndex = this.functionIndexArray(this.idx);
            this.idx = this.idx + 1;
        end
    end
end
