classdef SwitchingFunctionFactory < handle
    %SWITCHINGFUNCTIONFACTORY Summary of this class goes here
    properties (Access=public)
        writePath = ''
        namePrefix = ''
        outputName = ''
        functionData = []
    end

    methods
        % Constructor
        function obj = SwitchingFunctionFactory(functionData, writePath, namePrefix, outputName)
            if nargin == 0
                return
            end
            obj.functionData = functionData;
            
            obj.writePath = writePath;
            obj.namePrefix = namePrefix;
            obj.outputName = outputName;
        end

        switchingFunctionHandle = create(this, signature, collisionIndex, varargin);
        switchingFunctionHandle = get(this, signature, varargin);
    end

    methods (Static)
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

        function mtree = setFunctionCallAsReturnValue(mtree, outputName, rIndexEquals, rIndexExpr)
            cIndex = mtree_cIndex();
                        
            rIndex = struct('HEAD', struct(), 'BODY', struct());
            rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);
                        
            [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
                rIndexEquals, ...
                cIndex.indexLeftchild, ...
                {mtree.K.ID, outputName});
            
            [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
                rIndex.HEAD.HEAD, ...
                cIndex.indexLeftchild, ...
                {mtree.K.ID, outputName});
            
            mtree = traceReturnStatementToInputs(mtree, rIndexExpr);
        end
    end
end
