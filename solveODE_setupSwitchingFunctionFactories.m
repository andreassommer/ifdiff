function [switchFactory, jumpFactory, modelFactory] = solveODE_setupSwitchingFunctionFactories(datahandle)

%[switchFactory, jumpFactory] = solveODE_setupSwitchingFunctionFactories(datahandle)
% Setup factories for switching functions and jump functions.
%
%
%INPUT:
%   datahandle - Datahandle containing the preprocessed mtree and path information.
%       function handle
%
%
%OUPUT:
%   switchFactory - Generator/Finder for switching functions.
%       SwitchingFunctionFactory
%
%   jumpFactory - Generator/Finder for switching functions.
%       SwitchingFunctionFactory
%

config = makeConfig();
data = datahandle.getData();

mtreeArray = data.mtreeplus(3, :);
functionNameArray = data.mtreeplus(2, :);
functionData = PreprocessedFunctionData(mtreeArray, functionNameArray);
switchFactory = FixedBranchingFunctionStore( ...
    functionData, ...
    data.paths.preprocessed_switchingFunction, ...
    config.switchingFunctionNamePrefix, ...
    @(functionData, signature) SwitchingFunctionCreator(functionData, signature, data.paths.preprocessed_switchingFunction));
jumpFactory = FixedBranchingFunctionStore( ...
    functionData, ...
    data.paths.preprocessed_jumpFunction, ...
    config.jump.jumpFunctionNamePrefix, ...
    @(functionData, signature) JumpFunctionCreator(functionData, signature, data.paths.preprocessed_jumpFunction));
modelFactory = FixedBranchingFunctionStore( ...
    functionData, ...
    data.paths.preprocessed_modelFunction, ...
    config.modelFunctionNamePrefix, ...
    @(functionData, signature) ModelFunctionCreator(functionData, signature, data.paths.preprocessed_modelFunction));
end
