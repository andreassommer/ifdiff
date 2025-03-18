function switchingFunctionHandle = get(this, signature, varargin)
config = makeConfig();
collisionIndex = 1;
while true
    % For jump functions
    if nargin > 2
        namePrefix = config.jump.jumpFunctionNamePrefix;
    else
        namePrefix = config.switchingFunctionNamePrefix;
    end
    name = createSwitchingFunctionName(namePrefix, signature.rhsName, signature.hash, collisionIndex);
    if exist(name, 'file')
        % Check if the signature is actually correct
        testSignature = readSignatureFromFile([name '.m']);
        if strcmp(signature.str, testSignature)
            fprintf('[DEBUG] Reusing switching function with name "%s"\n', name);
            switchingFunctionHandle = str2func(name);
            return
        end
        
        % We have a collision and keep searching
        fprintf('[DEBUG] Collision detected in file "%s"\n with hash "%s"\n', name, signature.hash);
    else
        % Since we guarantee that collisions are numbered sequentially, there is no point in searching further
        fprintf('[DEBUG] Switching function with name "%s" not found\n', name);
        break
    end

    collisionIndex = collisionIndex + 1;
end

switchingFunctionHandle = this.create(signature, collisionIndex, varargin{:});
end
