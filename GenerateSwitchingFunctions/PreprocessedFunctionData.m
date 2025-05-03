classdef PreprocessedFunctionData < handle
    %this = PREPROCESSEDFUNCTIONDATA(mtreeArray, functionNameArray)
    %
    %Manages mtree information for functions preprocessed by IFDIFF.
    %Each mtree is assigned a unique index and all data related to an mtree is accessed via that index.
    %
    %INPUT:
    %   mtreeArray - Mtrees of the preprocessed functions.
    %       1xN cell array of mtreeplus
    %
    %   functionNameArray - Names of the preprocessed functions.
    %   Function names are matched to mtrees via the array index.
    %       1xN cell array of char array

    properties (Access=public)
        mtreeArray = {}
        functionNameArray = {}
    end

    properties (SetAccess=private)
        functionIndexToIdxMtreeMap = {};
        functionNameToIdxMtreeMap = {};
        helperFunctionCallInfoArray = {};
    end

    methods
        % Constructor
        function this = PreprocessedFunctionData(mtreeArray, functionNameArray)
            this.functionIndexToIdxMtreeMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

            if nargin == 0
                return
            end

            this.mtreeArray = mtreeArray;
            this.functionNameArray = functionNameArray;

            this.functionNameToIdxMtreeMap = containers.Map(functionNameArray, num2cell(1:length(mtreeArray)));
            this.helperFunctionCallInfoArray = cell(1, length(mtreeArray));
        end

        function idxMtree = getIdxMtreeFromFunctionCall(this, idxMtreeCaller, functionCallIndex)
            %idxMtree = this.GETIDXMTREEFROMFUNCTIONCALL(idxMtreeCaller, functionCallIndex)
            %
            %Determine mtree index of a function called in another mtree.
            %
            %INPUT:
            %   idxMtreeCaller - Index of the mtree containing the function call.
            %       positive integer
            %
            %   functionCallIndex - Index of the function call in the caller mtree.
            %       positive integer
            %
            %OUTPUT:
            %   idxMtree - Index of the mtree belonging to the function that was called.

            % Check if we have previously stored the result of this query.
            if this.functionIndexToIdxMtreeMap.isKey(functionCallIndex)
                idxMtree = this.functionIndexToIdxMtreeMap(functionCallIndex);
                return
            end

            % Find the name of the function that was called to determine the mtree index.
            calledFunctionName = this.getFunctionNameFromFunctionCall(idxMtreeCaller, functionCallIndex);
            idxMtree = this.functionNameToIdxMtreeMap(calledFunctionName);
            % Cache result for future access.
            this.functionIndexToIdxMtreeMap(functionCallIndex) = idxMtree;
        end

        function functionName = getFunctionNameFromFunctionCall(this, idxMtreeCaller, functionCallIndex)
            %functionName = this.GETFUNCTIONNAMEFROMFUNCTIONCALL(idxMtreeCaller, functionCallIndex)
            %
            %Determine name of a function called in an mtree.
            %
            %INPUT:
            %   idxMtreeCaller - Index of the mtree containing the function call.
            %       positive integer
            %
            %   functionCallIndex - Index of the function call in the caller mtree.
            %       positive integer
            %
            %OUTPUT:
            %   functionName - Name of the called function.

            cIndex = mtree_cIndex();

            functionCallInfo = this.getFunctionCallInfo(idxMtreeCaller, functionCallIndex);

            mtreeCaller = this.mtreeArray{idxMtreeCaller};
            functionName = mtreeCaller.C{mtreeCaller.T(functionCallInfo.rIndexFname, cIndex.stringTableIndex)};
        end

        function functionCallInfo = getFunctionCallInfo(this, idxMtree, varargin)
            %functionCallInfo = this.GETFUNCTIONCALLINFO(idxMtree)
            %functionCallInfo = this.GETFUNCTIONCALLINFO(idxMtree, functionCallIndex)
            %
            %Retrieve mtree row indices related to all/particular function calls in an mtree.
            %
            %INPUT:
            %   idxMtree - Index of the mtree containing the function calls.
            %       positive integer
            %
            %   functionCallIndex - (Optional) Index of (a) particular function call(s) in the mtree.
            %       positive integer
            %
            %OUTPUT:
            %   functionCallInfo - Mtree row indices related to the function call(s) (e.g. name, args, assignment etc.)
            %       MtreeCallInfo
            %
            %See also MTREECALLINFO

            % Check if the helper function call info was generated previously for this mtree.
            functionCallInfo = this.helperFunctionCallInfoArray{idxMtree};
            if isempty(functionCallInfo)
                % Create new and cache result for future access.
                functionCallInfo = MtreeCallInfo(this.mtreeArray{idxMtree});
                this.helperFunctionCallInfoArray{idxMtree} = functionCallInfo;
            end

            % Optionally, restrict access to only one function call index.
            if nargin > 2
                functionIndex = varargin{1};
                functionCallInfo = functionCallInfo.selectCallIndex(functionIndex);
            end
        end
    end
end
