function rhs = getRhsFromModelNum(datahandle, modelNum)
%rhs = GETRHSFROMMODELNUM(datahandle, modelNum)
%
%Return handle to RHS for a particular (potentially Filippov) submodel.
%
%If submodel RHS functions are configured to be exported, this function will attempt
%to find an existing model function or create a new one based on the submodel signature.
%
%INPUT:
%   datahandle - Contains stored information about RHS.
%       struct
%
%   modelNum - Number of the submodel in order of occurrence during initial solution via solveODE.
%       positive integer
%
%OUTPUT:
%   rhs - Handle to the submodel function corresponding to the signature.
%       function_handle

config = makeConfig();
data = datahandle.getData();

signature = data.SWP_detection.signature{modelNum};
% Check for Filippov case (multiple signatures)
if ~isscalar(signature)
    % TODO: Add option to also export Filippov RHS source code without ctrlifs.
    % Assume we don't start in Filippov (guaranteed since Filippov can only begin after a switch).
    switchingFunction = data.SWP_detection.switchingFunction{modelNum - 1};
    rhs = @(datahandle, t, y, p) slidingFilippovRHS_oneSwitch( ...
        datahandle, ...
        signature, ...
        switchingFunction, t, y, p);
    return
end

% Get transformed RHS source code without Ctrlifs
if config.removeCtrlifForSensComputation
    factory = data.codeGen.modelFactory;
    [rhs, collisionIndex] = factory.findExisting(signature);
    if isempty(rhs)
        rhs = factory.createNew(signature, collisionIndex);
    end
    return
end

% Default case, just return the preprocessed RHS and set the model number for correct ctrlif branching.
data.computeSensitivity.modelStage = modelNum;
datahandle.setData(data);
rhs = data.integratorSettings.preprocessed_rhs;
