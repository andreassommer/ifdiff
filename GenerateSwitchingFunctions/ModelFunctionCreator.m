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
            % Simplify mtrees
            for idxMtree=1:numel(this.exportMtreeArray)
                sortedMtree = mtreeplus(this.exportMtreeArray{idxMtree}.tree2str);
                this.exportMtreeArray{idxMtree} = deleteUnusedParameters(sortedMtree);
            end
        end
    end
end

