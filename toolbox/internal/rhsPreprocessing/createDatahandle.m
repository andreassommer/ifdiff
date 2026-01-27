function datahandle = createDatahandle(preprocessed)

config = makeConfig();
preprocessed.path = cd;

preprocessed.path = fullfile(preprocessed.path, config.preprocessedFunctionsDirectoryName);
if ~exist(preprocessed.path, 'dir')
    mkdir(preprocessed.path);
end

preprocessed.SwitchingFunctions_path = fullfile(preprocessed.path, config.switchingFunctionsDirectoryName);
if ~exist(preprocessed.SwitchingFunctions_path, 'dir')
    mkdir(preprocessed.path, config.switchingFunctionsDirectoryName);
end

preprocessed.JumpFunctions_path = fullfile(preprocessed.path, config.jump.jumpFunctionsDirectoryName);
if ~exist(preprocessed.JumpFunctions_path, 'dir')
    mkdir(preprocessed.path, config.jump.jumpFunctionsDirectoryName);
end

preprocessed.ModelFunctions_path = fullfile(preprocessed.path, config.modelFunctionsDirectoryName);
if ~exist(preprocessed.ModelFunctions_path, 'dir')
    mkdir(preprocessed.path, config.modelFunctionsDirectoryName);
end
addpath(genpath(preprocessed.path));

% export rhs
filepath_rhs = fullfile(preprocessed.path, [preprocessed.rhs{2,1}, '.m']);
tempFile = fopen(filepath_rhs, 'w');
treeStr = preprocessed.rhs{3,1}.tree2str;
% fprintf doesn't write the raw chars by default, which we want here however
fprintf(tempFile, '%s\n', treeStr);
fclose(tempFile);

if ~isempty(preprocessed.fcn)
    % export other functions in rhs
    l = size(preprocessed.fcn, 2);
    for i = 1:l
        filename = preprocessed.fcn{2,i};
        filepath = fullfile(preprocessed.path, [filename, '.m']);
        fcn = preprocessed.fcn{3,i};
        tempFile = fopen(filepath, 'w');
        treeStr = fcn.tree2str;
        % fprintf doesn't write the raw chars by default, which we want here however
        fprintf(tempFile, '%s\n', treeStr);
        fclose(tempFile);
    end
end

data.mtreeplus = cell(3,1 + size(preprocessed.fcn,2));
data.mtreeplus(:,1) = preprocessed.rhs(1:3,:);
data.mtreeplus(:,2:end) = preprocessed.fcn(1:3,:);

data.paths.preprocessed_rhs = preprocessed.path;
data.paths.preprocessed_switchingFunction = preprocessed.SwitchingFunctions_path;
data.paths.preprocessed_jumpFunction = preprocessed.JumpFunctions_path;
data.paths.preprocessed_modelFunction = preprocessed.ModelFunctions_path;

data.caseCtrlif = config.caseCtrlif.default;

data.sliding.storeSlidingInfo = config.storeSlidingInfo;

datahandle = makeClosure(data);
end
