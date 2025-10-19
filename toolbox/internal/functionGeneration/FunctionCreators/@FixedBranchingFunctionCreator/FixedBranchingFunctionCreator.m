classdef FixedBranchingFunctionCreator
    %this = FIXEDBRANCHINGFUNCTIONCREATOR(functionData, signature, writePath, functionNamePrefix, functionOutputName)
    %
    %Create a function with fixed branching from a signature (one-time-use).
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
    %
    %   functionNamePrefix - Prefix added to the name of the function to be created.
    %   Primarily used to differentiate between different types of functions.
    %       char array
    %
    %   functionOutputName - Name of the output of the function to be created.
    %   Primarily used to differentiate between different types of functions.
    %       char array

    properties (SetAccess=immutable)
        functionData
        signature
        numCtrlif
        writePath
        functionNamePrefix
        functionOutputName
    end

    properties (SetAccess=protected)
        exportMtreeArray
        funcIter
        functionName
    end

    methods
        % Constructor
        function this = FixedBranchingFunctionCreator(functionData, signature, writePath, functionNamePrefix, functionOutputName)
            this.functionData = functionData;
            this.signature = signature;
            this.numCtrlif = numel(signature.ctrlifIndex);
            this.writePath = writePath;
            this.functionNamePrefix = functionNamePrefix;
            this.functionOutputName = functionOutputName;

            this.exportMtreeArray = this.functionData.mtreeArray(1);
            this.funcIter = FunctionIterator(this.functionData);
        end

        functionHandle = create(this, collisionIndex)
        this = fixBranching(this, idxCtrlif)
        this = handleHelperCallsBeforeCtrlif(this, idxCtrlif, isReturn)
    end

    methods (Abstract)
        % The last ctrlif is usually somehow involved in deriving the return value of the new function.
        % This return value is different for different types of functions (i.e. switching/jump/model functions).
        this = handleLastCtrlif(this);
    end
end
