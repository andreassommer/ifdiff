classdef ModelFunctionCreator < FixedBranchingFunctionCreator
    %this = MODELFUNCTIONCREATOR(functionData, signature, writePath)
    %
    %Create model function from a signature (one-time-use).
    %
    %INPUT:
    %   functionData - Data related to preprocessed functions used to create new functions.
    %       PreprocessedFunctionData
    %
    %   signature - Signature of the function to be created.
    %       BranchingSignature
    %
    %   writePath - Absolute path to directory in which the source code of the new function will be placed.
    %       char array

    methods
        % Constructor
        function this = ModelFunctionCreator(functionData, signature, writePath)
            config = makeConfig();
            this = this@FixedBranchingFunctionCreator( ...
                functionData, ...
                signature, ...
                writePath, ...
                config.modelFunctionNamePrefix, ...
                '');
        end

        function this = handleLastCtrlif(this)
            % Fix branching of final ctrlif and simplify function (output is unchanged).
            this = this.handleHelperCallsBeforeCtrlif(this.numCtrlif, true);
            this = this.fixBranching(this.numCtrlif);

            for idxMtree=1:numel(this.exportMtreeArray)
                mtree = this.exportMtreeArray{idxMtree};
                this.exportMtreeArray{idxMtree} = traceReturnStatementToInputs(mtree, mtree_getReturnStatement(mtree));
            end
        end
    end
end
