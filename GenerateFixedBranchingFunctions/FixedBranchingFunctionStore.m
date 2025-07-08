classdef FixedBranchingFunctionStore
    %this = FIXEDBRANCHINGFUNCTIONSTORE(functionData, writePath, namePrefix, makeCreator)
    %
    %Retrieve existing fixed branching functions from signature or create new ones.
    %
    %INPUT:
    %   functionData - Data related to preprocessed functions used to create new functions.
    %       PreprocessedFunctionData
    %
    %   writePath - Absolute path to directory in which the source code of new functions will be placed.
    %       char array
    %
    %   namePrefix - Prefix added to the name of functions.
    %   Primarily used to differentiate between different types of functions.
    %       char array
    %
    %   makeCreator - Constructor of the class used to create new functions.
    %   The creator class must be a subclass of FixedBranchingFunctionCreator.
    %       function_handle
    %
    %See also PreprocessedFunctionData, FixedBranchingFunctionCreator.

    properties (Access=public)
        functionData = []
        writePath = ''
        namePrefix = ''
        makeCreator = []
    end

    methods
        % Constructor
        function this = FixedBranchingFunctionStore(functionData, writePath, namePrefix, makeCreator)
            if nargin == 0
                return
            end

            this.functionData = functionData;
            this.writePath = writePath;
            this.namePrefix = namePrefix;
            this.makeCreator = makeCreator;
        end

        function [functionHandle, collisionIndex] = findExisting(this, signature)
            %[functionHandle, collisionIndex] = this.FINDEXISTING(signature)
            %
            %Find an existing function based on a signature.
            %
            %INPUT:
            %   signature - Signature of the function to be found.
            %       BranchingSignature
            %
            %OUTPUT:
            %   functionHandle - Handle to the found function if it exists or empty array otherwise.
            %       function handle | empty array
            %
            %   collisionIndex - Index used to avoid hash collisions at which the search stopped.
            %   Can be used in a subsequent call to this.createNew to create a new function instead.
            %       positive integer
            %
            %See also BRANCHINGSIGNATURE

            config = makeConfig();

            functionHandle = [];
            collisionIndex = 1;

            while config.reuseSwitchingFunctions
                functionName = createSwitchingFunctionName(this.namePrefix, signature.rhsName, signature.hash, collisionIndex);
                % RHS is always assigned export index 1.
                functionName = getExportFunctionName(functionName, 1);
                if exist(functionName, 'file')
                    % Check whether the signature is actually correct or merely the result of a hash collision.
                    testSignature = readSignatureFromFile([functionName '.m']);
                    if strcmp(signature.str, testSignature)
                        if config.debugMode
                            fprintf('[DEBUG] Reusing switching function with name "%s"\n', functionName);
                        end
                        functionHandle = str2func(functionName);
                        return
                    end

                    % We have a hash collision and keep searching.
                    if config.debugMode
                        fprintf('[DEBUG] Collision detected in file "%s"\n with hash "%s"\n', functionName, signature.hash);
                    end
                else
                    % Since we guarantee that collisions are numbered sequentially, there is no point in searching further.
                    if config.debugMode
                        fprintf('[DEBUG] Switching function with name "%s" not found\n', functionName);
                    end
                    break
                end

                collisionIndex = collisionIndex + 1;
            end
        end

        function functionHandle = createNew(this, signature, collisionIndex)
            %functionHandle = this.CREATENEW(signature, collisionIndex)
            %
            %Create a new function from a signature.
            %
            %INPUT:
            %   signature - Signature of the function to be created.
            %       BranchingSignature
            %
            %   collisionIndex - Index used to avoid hash collisions for the name of the new function.
            %       positive integer
            %
            %OUTPUT:
            %   functionHandle - Handle to the newly created function.
            %       function_handle
            %
            %See also FIXEDBRANCHINGFUNCTIONCREATOR, BRANCHINGSIGNATURE.

            creator = this.makeCreator(this.functionData, signature);
            functionHandle = creator.create(collisionIndex);
        end
    end
end
