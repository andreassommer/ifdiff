classdef SwitchingFunctionFactory < handle
    %SWITCHINGFUNCTIONFACTORY Summary of this class goes here
    properties (Access=public)
        mtreeArray = {}
        functionNameArray = {}
        writePath = ''
    end

    properties (SetAccess=private)
        functionIndexToIdxMtreeMap = {};
        functionNameToIdxMtreeMap = {};
        helperFunctionCallInfoArray = {};
    end

    methods
        % Constructor
        function obj = SwitchingFunctionFactory(mtreeArray, functionNameArray, writePath)
            obj.functionIndexToIdxMtreeMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

            if nargin == 0
                return
            end

            obj.mtreeArray = mtreeArray;
            obj.functionNameArray = functionNameArray;
            obj.writePath = writePath;
                        
            obj.functionNameToIdxMtreeMap = containers.Map(functionNameArray, num2cell(1:length(mtreeArray)));
            obj.helperFunctionCallInfoArray = cell(1, length(mtreeArray));
        end

        function idxMtree = functionIndexToIdxMtree(this, functionIndex, idxCallerMtree)
            if this.functionIndexToIdxMtreeMap.isKey(functionIndex)
                idxMtree = this.functionIndexToIdxMtreeMap(functionIndex);
                return
            end
            
            helperFunctionName = this.functionIndexToFunctionName(functionIndex, idxCallerMtree);
            idxMtree = this.functionNameToIdxMtreeMap(helperFunctionName);
            this.functionIndexToIdxMtreeMap(functionIndex) = idxMtree;
        end

        function helperFunctionCallInfo = getHelperFunctionCallInfo(this, idxMtree, varargin)
            helperFunctionCallInfo = this.helperFunctionCallInfoArray{idxMtree};
            if isempty(helperFunctionCallInfo)
                helperFunctionCallInfo = SwitchingFunctionFactory.createHelperFunctionCallInfo(this.mtreeArray{idxMtree});
                this.helperFunctionCallInfoArray{idxMtree} = helperFunctionCallInfo;
            end

            if nargin > 0
                functionIndex = varargin{1};
                helperFunctionCallInfo = helperFunctionCallInfo.setActiveIndex(functionIndex);
            end
        end

        function functionName = functionIndexToFunctionName(this, functionIndex, idxCallerMtree)
            cIndex = mtree_cIndex;

            helperFunctionCallInfo = this.getHelperFunctionCallInfo(idxCallerMtree, functionIndex);

            callerMtree = this.mtreeArray{idxCallerMtree};
            functionName = callerMtree.C{callerMtree.T(helperFunctionCallInfo.rIndexFname, cIndex.stringTableIndex)};
        end

        
    end

    methods (Static)
        helperFunctionCallInfo = createHelperFunctionCallInfo(mtree);

        function mtree = adjustFunctionCall(mtree, newName, rIndexCall, rIndexArg3)          
            cIndex = mtree_cIndex();
            
            % Adjust the function call
            [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
                rIndexCall, ...
                cIndex.indexLeftchild, ...
                {mtree.K.ID, newName});
            
            mtree = mtree_connectNodes(...
                mtree, ...
                rIndexCall,...
                rIndexArg3,...
                cIndex.indexRightchild);
        end

        function mtree = setFunctionCallAsReturnValue(mtree, rIndexEquals, rIndexExpr)
            config = makeConfig();
            cIndex = mtree_cIndex();
                        
            rIndex = struct('HEAD', struct(), 'BODY', struct());
            rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);
                        
            [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
                rIndexEquals, ...
                cIndex.indexLeftchild, ...
                {mtree.K.ID, config.switchingFunctionOutputName});
            
            [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
                rIndex.HEAD.HEAD, ...
                cIndex.indexLeftchild, ...
                {mtree.K.ID, config.switchingFunctionOutputName});
            
            % Delete everything after the new return
            mtree.T(rIndexExpr, cIndex.indexNextNode) = 0;
        end
    end
end
