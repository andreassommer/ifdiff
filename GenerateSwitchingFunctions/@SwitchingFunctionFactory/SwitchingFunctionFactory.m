classdef SwitchingFunctionFactory
    %this = SWITCHINGFUNCTIONFACTORY(functionData, writePath, namePrefix, outputName)
    %
    %Retrieve existing switching/jump functions from signature or create new ones.
    %
    %INPUT:
    %   functionData - Data related to preprocessed functions used to create new switching/jump functions.
    %       PreprocessedFunctionData
    %
    %   writePath - Absolute path to directory in which the source code of new functions will be placed.
    %       char array
    %
    %   namePrefix - Prefix added to the name of functions.
    %   Primarily used to differentiate between switching and jump functions (e.g. sw_ and jump_).
    %       char array
    %
    %   outputName - Name of the output variable for functions.
    %   Primarily used to differentiate between switching and jump functions (e.g. switching_value and jump_increment).
    %       char array
    %
    %See also PreprocessedFunctionData, SwitchingFunctionSignature

    properties (Access=public)
        functionData
        writePath = ''
        namePrefix = ''
        outputName = ''
    end

    methods
        % Constructor
        function this = SwitchingFunctionFactory(functionData, writePath, namePrefix, outputName)
            if nargin == 0
                this.functionData = PreprocessedFunctionData();
                return
            end

            this.functionData = functionData;
            this.writePath = writePath;
            this.namePrefix = namePrefix;
            this.outputName = outputName;
        end

        switchingFunctionHandle = create(this, signature, collisionIndex, varargin);
        switchingFunctionHandle = get(this, signature, varargin);
    end
end
