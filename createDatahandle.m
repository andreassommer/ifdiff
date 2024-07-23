function datahandle = createDatahandle(preprocessed)



config = makeConfig();
preprocessed.path = cd; 

preprocessed.path = fullfile(preprocessed.path, config.preprocessedFunctionsDirectoryName);
if ~exist(preprocessed.path, 'dir')
    mkdir(preprocessed.rhs_path, config.preprocessedFunctionsDirectoryName)
end

preprocessed.SwitchingFunctions_path = fullfile(preprocessed.path, config.switchingFunctionsDirectoryName);
if ~exist(preprocessed.SwitchingFunctions_path, 'dir')
    mkdir(preprocessed.path, config.switchingFunctionsDirectoryName);
end
addpath(genpath(preprocessed.path));

% export rhs
filepath_rhs = fullfile(preprocessed.path, [preprocessed.rhs{2,1}, '.m']);
tempFile = fopen(filepath_rhs, 'w');
fprintf(tempFile, preprocessed.rhs{3,1}.tree2str);
fclose(tempFile);



if ~isempty(preprocessed.fcn)
    % export other functions in rhs
    l = size(preprocessed.fcn, 2);
    for i = 1:l
        filename = preprocessed.fcn{2,i}; 
        filepath = fullfile(preprocessed.path, [filename, '.m']);
        fcn = preprocessed.fcn{3,i}; 
        tempFile = fopen(filepath, 'w');
        fprintf(tempFile, fcn.tree2str);
        fclose(tempFile);
    end
end
% save mtreeobj into a datahandle
data.mtreeplus = cell(3,1 + size(preprocessed.fcn,2)); 
data.mtreeplus(:,1) = preprocessed.rhs; 
data.mtreeplus(:,2:end) = preprocessed.fcn; 


data.paths.preprocessed_rhs = preprocessed.path;
data.paths.preprocessed_switchingFunction = preprocessed.SwitchingFunctions_path; 

data.caseCtrlif = config.caseCtrlif.default; 








% create closure
datahandle = makeClosure(data);

end























