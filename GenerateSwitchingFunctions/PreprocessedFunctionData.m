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
            %Retrieve mtree row indices related to all/a particular function call(s) in an mtree.
            %
            %INPUT:
            %   idxMtree - Index of the mtree containing the function calls.
            %       positive integer
            %
            %   functionCallIndex - (Optional) Index of a particular function call in the mtree.
            %       positive integer
            %
            %OUTPUT:
            %   functionCallInfo - Mtree row indices related to the function call(s) (e.g. name, args, assignment etc.)
            %       MtreeHelperFunctionCallInfo
            %
            %See also MTREEHELPERFUNCTIONCALLINFO

            % Check if the helper function call info was generated previously for this mtree.
            functionCallInfo = this.helperFunctionCallInfoArray{idxMtree};
            if isempty(functionCallInfo)
                % Create new and cache result for future access.
                functionCallInfo = this.createHelperFunctionCallInfo(this.mtreeArray{idxMtree});
                this.helperFunctionCallInfoArray{idxMtree} = functionCallInfo;
            end

            % Optionally, restrict access to only one function call index.
            if nargin > 0
                functionIndex = varargin{1};
                functionCallInfo = functionCallInfo.setActiveIndex(functionIndex);
            end
        end
    end

    methods (Static)
        function helperFunctionCallInfo = createHelperFunctionCallInfo(mtree)
            % How it works:
            % 1. Get all nodes corresponding to setFunctionIndex calls
            % 2. Extract the arguments.
            % 2a. If the second argument is a -1, then we are in the RHS and the function index is stored in the first argument
            % 2b. Otherwise, we are in a helper function and the second argument holds the function_index
            % 3. Get the expression node of the actual helper function call.
            % 4. From there collect more useful nodes for the helper function, i.e. the EXPR, EQUALS, CALL, FNAME, and ARG (if any) nodes.
            % Return: For all helper functions, their function index and rIndex of nodes relevant to the function call.

            config = makeConfig();
            cIndex = mtree_cIndex();

            % Find all subtrees of updateFunctionIndex calls and get their row indices
            rIndexUpdateFunctionIndex = mtree.mtfind('String', config.function_indexUpdateFunctionName).indices;

            % There are no updateFunctionIndex calls
            if isempty(rIndexUpdateFunctionIndex)
                helperFunctionCallInfo = [];
                return
            end

            % Get the first and second argument of the updateFunctionIndex call
            rIndexUpdateFunctionIndexCall = mtree.T(rIndexUpdateFunctionIndex, cIndex.indexParentNode)';
            rIndexUpdateFunctionIndexArg1 = mtree.T(rIndexUpdateFunctionIndexCall, cIndex.indexRightchild)';
            rIndexUpdateFunctionIndexArg2 = mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.indexNextNode)';

            % We can acquire the row indices of a helper function call by finding the expression node of the update function
            % and then following the nextNode link.
            rIndexUpdateFunctionIndexExpr = mtree_findNode(mtree, rIndexUpdateFunctionIndexCall, mtree.K.EXPR);

            % Store important row indices for the helper function call in output
            helperFunctionCallInfo = MtreeHelperFunctionCallInfo;
            helperFunctionCallInfo.rIndexExpr = mtree.T(rIndexUpdateFunctionIndexExpr, cIndex.indexNextNode)';
            helperFunctionCallInfo.rIndexEquals = mtree.T(helperFunctionCallInfo.rIndexExpr, cIndex.indexLeftchild)';
            helperFunctionCallInfo.rIndexCall = mtree.T(helperFunctionCallInfo.rIndexEquals, cIndex.indexRightchild)';
            helperFunctionCallInfo.rIndexFname = mtree.T(helperFunctionCallInfo.rIndexCall, cIndex.indexLeftchild)';

            % Get row indices of function arguments (if any)
            % TODO: Clean up the mtree_rIndex_getFunctionArguments function to make this call less awkward
            tmpIndex = struct;
            tmpIndex.Call = helperFunctionCallInfo.rIndexCall;
            tmpIndex = mtree_rIndex_getFunctionArguments(mtree, tmpIndex, 'Call');
            helperFunctionCallInfo.rIndexArgs = tmpIndex.Arg;

            % Finally, store the function indices of the helper function calls that were found
            % Note that the function index and its corresponding rIndex information should be stored at the same position,
            % so that we can associate them with each other.

            % For the updateFunctionIndex arguments:
            % If the second argument is -1, then we are in the RHS and the first argument contains the function index.
            % Otherwise, we are in a helper function and the second argument contains the function index.
            updateFunctionIndexArg1 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.stringTableIndex)))';

            % Note: -1 can be expressed as UMINUS(INT 1) or INT -1
            if all(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.kindOfNode) == mtree.K.UMINUS)
                isRhs = true;
            else
                updateFunctionIndexArg2 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.stringTableIndex)))';
                isRhs = all(updateFunctionIndexArg2 == -1);
            end

            if isRhs
                helperFunctionCallInfo.functionIndex = updateFunctionIndexArg1;
            else
                helperFunctionCallInfo.functionIndex = updateFunctionIndexArg2;
            end
        end
    end
end
