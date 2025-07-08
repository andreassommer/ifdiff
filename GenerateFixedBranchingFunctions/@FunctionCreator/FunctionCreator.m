classdef FunctionCreator
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
        function this = FunctionCreator(functionData, signature, writePath, functionNamePrefix, functionOutputName)
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
        this = handleLastCtrlif(this);
    end
end

