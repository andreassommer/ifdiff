sigArray = SwitchingFunctionSignature.empty;

% Normal canonical example
% rhsName = 'canonicalExampleRHS';
% sigArray(end + 1) = SwitchingFunctionSignature(rhsName, false, 1, {0});
% sigArray(end + 1) = SwitchingFunctionSignature(rhsName, [true, false], [1, 2], {0, 0});

% % Canonical example with a helper function
rhsName = 'helperCanonicalExampleRHS';
sigArray(end + 1) = SwitchingFunctionSignature(rhsName, false, 1, {0});
sigArray(end + 1) = SwitchingFunctionSignature(rhsName, [true, false], [1, 2], {0, 1});

datahandle = prepareDatahandleForIntegration(rhsName);
data = datahandle.getData();
functionNames = data.mtreeplus(2, :);
mtreeArray = data.mtreeplus(3, :);

writePath = 'PreprocessedFunctions/SwitchingFunctions';

factory = SwitchingFunctionFactory(mtreeArray, functionNames, writePath);

handleArray = cell(1, length(sigArray));
for i = 1:length(sigArray)
    handleArray{i} = factory.create(sigArray(i));
end
