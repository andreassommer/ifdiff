function switchingFunctionHandle = get(this, signature, varargin)
%switchingFunctionHandle = this.GET(signature)
%switchingFunctionHandle = this.GET(signature, ctrlJumpInfo)
%
%Find an existing switching/jump function based on a signature or, if not found, create a new one.
%
%INPUT:
%   signature - Signature of the switching/jump function to be found/created.
%       SwitchingFunctionSignature
%
%   ctrljumpInfo - (Optional) Contains information that ties ctrlif indices to ctrljump expressions.
%   If provided, this function will find/create a jump function instead of a switching function.
%       3xN array of integers
%
%OUTPUT:
%   switchingFunctionHandle - Handle to the found/created switching or jump function.
%
%See also SWITCHINGFUNCTIONSIGNATURE

config = makeConfig();

collisionIndex = 1;
while config.reuseSwitchingFunctions
    name = createSwitchingFunctionName(this.namePrefix, signature.rhsName, signature.hash, collisionIndex);
    name = getExportFunctionName(name, 1); % RHS always gets index 1
    if exist(name, 'file')
        % Check if the signature is actually correct
        testSignature = readSignatureFromFile([name '.m']);
        if strcmp(signature.str, testSignature)
            if config.debugMode
                fprintf('[DEBUG] Reusing switching function with name "%s"\n', name);
            end
            switchingFunctionHandle = str2func(name);
            return
        end

        % We have a collision and keep searching
        if config.debugMode
            fprintf('[DEBUG] Collision detected in file "%s"\n with hash "%s"\n', name, signature.hash);
        end
    else
        % Since we guarantee that collisions are numbered sequentially, there is no point in searching further
        if config.debugMode
            fprintf('[DEBUG] Switching function with name "%s" not found\n', name);
        end
        break
    end

    collisionIndex = collisionIndex + 1;
end

switchingFunctionHandle = this.create(signature, collisionIndex, varargin{:});
end
