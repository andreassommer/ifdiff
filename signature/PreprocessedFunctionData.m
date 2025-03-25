classdef PreprocessedFunctionData < handle
    %PREPROCESSEDFUNCTIONDATA   Manages shared preprocessed function data used for switching function generation.

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
        function obj = PreprocessedFunctionData(mtreeArray, functionNameArray)
            obj.functionIndexToIdxMtreeMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

            if nargin == 0
                return
            end

            obj.mtreeArray = mtreeArray;
            obj.functionNameArray = functionNameArray;

            obj.functionNameToIdxMtreeMap = containers.Map(functionNameArray, num2cell(1:length(mtreeArray)));
            obj.helperFunctionCallInfoArray = cell(1, length(mtreeArray));
        end

        function idxMtree = functionIndexToIdxMtree(this, functionIndex, idxCallerMtree)
            % Given the index of an mtree and a function index of a call contained within that mtree,
            % determine the index of the mtree of the function corresponding to that function index.

            % Check if we have previously stored the result of this query already
            if this.functionIndexToIdxMtreeMap.isKey(functionIndex)
                idxMtree = this.functionIndexToIdxMtreeMap(functionIndex);
                return
            end

            helperFunctionName = this.functionIndexToFunctionName(functionIndex, idxCallerMtree);
            idxMtree = this.functionNameToIdxMtreeMap(helperFunctionName);
            % Cache result for future access
            this.functionIndexToIdxMtreeMap(functionIndex) = idxMtree;
        end

        function functionName = functionIndexToFunctionName(this, functionIndex, idxCallerMtree)
            % Given the index of an mtree and a function index of a call contained within that mtree,
            % determine the name of the function corresponding to that function index.
            cIndex = mtree_cIndex;

            helperFunctionCallInfo = this.getHelperFunctionCallInfo(idxCallerMtree, functionIndex);

            callerMtree = this.mtreeArray{idxCallerMtree};
            functionName = callerMtree.C{callerMtree.T(helperFunctionCallInfo.rIndexFname, cIndex.stringTableIndex)};
        end

        function helperFunctionCallInfo = getHelperFunctionCallInfo(this, idxMtree, varargin)
            % Given the index of an mtree and optionally a function index,
            % retrieve the relevant rIndex entries for helper function calls in the mtree.
            
            % Check if the helper function call info was generated previously for this mtree.
            helperFunctionCallInfo = this.helperFunctionCallInfoArray{idxMtree};
            if isempty(helperFunctionCallInfo)
                % Create new and cache result for future access.
                helperFunctionCallInfo = this.createHelperFunctionCallInfo(this.mtreeArray{idxMtree});
                this.helperFunctionCallInfoArray{idxMtree} = helperFunctionCallInfo;
            end
            
            % Optionally, restrict access to only one function index.
            if nargin > 0
                functionIndex = varargin{1};
                helperFunctionCallInfo = helperFunctionCallInfo.setActiveIndex(functionIndex);
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
