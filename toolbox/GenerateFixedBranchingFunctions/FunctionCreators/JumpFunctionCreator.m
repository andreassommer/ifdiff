classdef JumpFunctionCreator < FixedBranchingFunctionCreator
    %this = JUMPFUNCTIONCREATOR(functionData, signature, writePath)
    %
    %Create jump function from a signature (one-time-use).
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
        function this = JumpFunctionCreator(functionData, signature, writePath)
            config = makeConfig();
            this = this@FixedBranchingFunctionCreator( ...
                functionData, ...
                signature, ...
                writePath, ...
                config.jump.jumpFunctionNamePrefix, ...
                config.jump.jumpFunctionOutputName);
        end

        function this = handleLastCtrlif(this)
            % Set return value of function to jump update computed in the jump-if-block.
            this = this.handleHelperCallsBeforeCtrlif(this.numCtrlif, true);
            this = this.fixBranching(this.numCtrlif);

            this.exportMtreeArray{this.funcIter.idxMtreeCallerExport} = replaceCtrljumpByReturn( ...
                this.exportMtreeArray{this.funcIter.idxMtreeCallerExport}, ...
                this.signature.ctrlifIndex(this.numCtrlif), ...
                this.functionData.ctrljumpInfo);
        end
    end
end
