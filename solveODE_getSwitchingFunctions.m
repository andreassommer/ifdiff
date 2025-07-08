function solveODE_getSwitchingFunctions(datahandle, factory)
%SOLVEODE_GETSWITCHINGFUNCTIONS(datahandle, factory)
%
%Retrieve the switching functions for all ctrlif switches recorded in the datahandle during the last integration step.
%We have to retrieve all switching functions, to determine their switching points and find out which one has switched first.
%
%INPUT:
%   datahandle - Datahandle containing the signature information for the last integration step.
%       function handle
%
%   factory - Switching function factory used to find existing switching functions and create new ones.
%       SwitchingFunctionFactory
%
%   The following datahandle fields are relevant:
%   SWP_detection.switchingIndices - Signature indices where ctrlif conditions have flipped in the last integration step.
%       1xN array of positive integers
%
%   SWP_detection.switch_cond_t1 - Switch conditions observed before the switch.
%       1xM array of positive integers
%
%   SWP_detection.ctrlif_index_t1 - Ctrlif indices observed before the switch.
%       1xM array of positive integers
%
%   SWP_detection.function_index_t1 - Function indices observed before the switch.
%       Mx1 cell array of 1x? arrays of positive integers
%
%OUTPUT:
%   SWP_detection.switchingfunctionhandles - Updated field in datahandle containing handles to the main switching functions.
%       Nx1 cell array of function handles
%
%See also SWITCHINGFUNCTIONFACTORY

data = datahandle.getData();
rhsName = data.mtreeplus{2, 1};

nSwitches = length(data.SWP_detection.switchingIndices);
switchingfunctionhandles = cell(nSwitches, 1);
for idxSwitch = 1:nSwitches
    % Prepare signature.
    idxSignatureSwitchCtrlif = data.SWP_detection.switchingIndices(idxSwitch);
    signature = BranchingSignature( ...
        rhsName, ...
        data.SWP_detection.switch_cond_t1(1:idxSignatureSwitchCtrlif), ...
        data.SWP_detection.ctrlif_index_t1(1:idxSignatureSwitchCtrlif), ...
        data.SWP_detection.function_index_t1(1:idxSignatureSwitchCtrlif) ...
        );
    % Check if switching function exists or create a new one otherwise.
    [switchingFunctionHandle, collisionIndex] = factory.findExisting(signature);
    if isempty(switchingFunctionHandle)
        switchingFunctionHandle = factory.createNew(signature, collisionIndex);
    end

    switchingfunctionhandles{idxSwitch} = switchingFunctionHandle;
end

% Store function handles to main switching functions in datahandle.
data.SWP_detection.switchingfunctionhandles = switchingfunctionhandles;
datahandle.setData(data);
end
