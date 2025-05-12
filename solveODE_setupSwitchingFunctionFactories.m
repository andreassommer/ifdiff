function [switchFactory, jumpFactory] = solveODE_setupSwitchingFunctionFactories(datahandle)

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
switchFactory = SwitchingFunctionFactory( ...
    functionData, ...
    data.paths.preprocessed_switchingFunction, ...
    config.switchingFunctionNamePrefix, ...
    config.switchingFunctionOutputName ...
    );
jumpFactory = SwitchingFunctionFactory( ...
    functionData, ...
    data.paths.preprocessed_jumpFunction, ...
    config.jump.jumpFunctionNamePrefix, ...
    config.jump.jumpFunctionOutputName ...
    );
end