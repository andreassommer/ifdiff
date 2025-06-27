classdef ModelFunctionCreator < FunctionCreator
    methods
        % Constructor
        function this = ModelFunctionCreator(functionData, signature, writePath)
            config = makeConfig();
            this = this@FunctionCreator( ...
                functionData, ...
                signature, ...
                writePath, ...
                config.modelFunctionNamePrefix, ...
                '');
        end

        function this = handleLastCtrlif(this)
            this = this.handleHelperCallsBeforeCtrlif(this.numCtrlif, true);
            this = this.fixBranching(this.numCtrlif);

            for idxMtree=1:numel(this.exportMtreeArray)
                mtree = this.exportMtreeArray{idxMtree};
                this.exportMtreeArray{idxMtree} = traceReturnStatementToInputs(mtree, mtree_getReturnStatement(mtree));
            end
        end
    end
end

