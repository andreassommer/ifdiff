sigArray = SwitchingFunctionSignature.empty;

% Normal canonical example
rhsName = 'canonicalExampleRHS';
sigArray(end + 1) = SwitchingFunctionSignature(rhsName, true, 1, {0});
sigArray(end + 1) = SwitchingFunctionSignature(rhsName, [false, true], [1, 2], {0, 0});

% Canonical example with a helper function
%rhsName = 'helperCanonicalExampleRHS';
%sigArray(end + 1) = SwitchingFunctionSignature(rhsName, true, 1, {0});
%sigArray(end + 1) = SwitchingFunctionSignature(rhsName, [false, true], [1, 2], {0, 0});

datahandle = prepareDatahandleForIntegration(rhsName);
data = datahandle.getData();
mtreeArray = data.mtreeplus(3, :);

writePath = 'PreprocessedFunctions/SwitchingFunctions';

handleArray = cell(1, length(sigArray));
for i = 1:length(sigArray)
    handleArray{i} = createSwitchingFcnFromSignature(sigArray(i), mtreeArray, writePath);
end
