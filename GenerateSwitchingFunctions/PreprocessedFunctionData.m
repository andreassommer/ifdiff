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
        ctrljumpInfo = {}
    end

    properties (SetAccess=private)
        functionIndexToIdxMtreeMap = {};
        functionNameToIdxMtreeMap = {};
        helperCallInfoArray = {};
        ctrlifCallInfoArray = {};
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

            this.helperCallInfoArray = cell(1, length(mtreeArray));
            this.ctrlifCallInfoArray = cell(1, length(mtreeArray));
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
            %       positive integer

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
            %       char array

            cIndex = mtree_cIndex();

            functionCallInfo = this.getHelperCallInfo(idxMtreeCaller, functionCallIndex);

            mtreeCaller = this.mtreeArray{idxMtreeCaller};
            functionName = mtreeCaller.C{mtreeCaller.T(functionCallInfo.rIndexFname, cIndex.stringTableIndex)};
        end

        function helperCallInfo = getHelperCallInfo(this, idxMtree, varargin)
            %functionCallInfo = this.GETHELPERCALLINFO(idxMtree)
            %functionCallInfo = this.GETHELPERCALLINFO(idxMtree, functionIndex)
            %
            %Retrieve mtree row indices related to all/particular helper function calls in an mtree.
            %
            %INPUT:
            %   idxMtree - Index of the mtree containing the function calls.
            %       positive integer
            %
            %   functionIndex - (Optional) Index of (a) particular helper function call(s) in the mtree.
            %       1xN array of positive integers
            %
            %OUTPUT:
            %   helperCallInfo - Mtree row indices related to the function call(s) (e.g. name, args, assignment etc.)
            %       MtreeHelperCallInfo
            %
            %See also MTREEHELPERCALLINFO

            % Check if the helper function call info was generated previously for this mtree.
            helperCallInfo = this.helperCallInfoArray{idxMtree};
            if isempty(helperCallInfo)
                % Create new and cache result for future access.
                helperCallInfo = MtreeHelperCallInfo(this.mtreeArray{idxMtree});
                this.helperCallInfoArray{idxMtree} = helperCallInfo;
            end

            % Optionally, restrict access to only one function index.
            if nargin > 2
                functionIndex = varargin{1};
                helperCallInfo = helperCallInfo.selectCallIndex(functionIndex);
            end
        end

        function ctrlifCallInfo = getCtrlifCallInfo(this, idxMtree, varargin)
            %functionCallInfo = this.GETCTRLIFCALLINFO(idxMtree)
            %functionCallInfo = this.GETCTRLIFCALLINFO(idxMtree, ctrlifIndex)
            %
            %Retrieve mtree row indices related to all/particular ctrlif calls in an mtree.
            %
            %INPUT:
            %   idxMtree - Index of the mtree containing the ctrlif calls.
            %       positive integer
            %
            %   functionCallIndex - (Optional) Index of (a) particular ctrlif call(s) in the mtree.
            %       1xN array of positive integers
            %
            %OUTPUT:
            %   ctrlifCallInfo - Mtree row indices related to the ctrlif call(s) (e.g. name, args, assignment etc.)
            %       MtreeCtrlifCallInfo
            %
            %See also MTREECTRLIFCALLINFO

            % Check if the ctrlif call info was generated previously for this mtree.
            ctrlifCallInfo = this.ctrlifCallInfoArray{idxMtree};
            if isempty(ctrlifCallInfo)
                % Create new and cache result for future access.
                ctrlifCallInfo = MtreeCtrlifCallInfo(this.mtreeArray{idxMtree});
                this.ctrlifCallInfoArray{idxMtree} = ctrlifCallInfo;
            end

            % Optionally, restrict access to only one ctrlif index.
            if nargin > 2
                ctrlifIndex = varargin{1};
                ctrlifCallInfo = ctrlifCallInfo.selectCallIndex(ctrlifIndex);
            end
        end
    end
end
