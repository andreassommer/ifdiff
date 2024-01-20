function datahandle = createDatahandle(preprocessed)



config = makeConfig();
preprocessed.path = pwd; 

preprocessed.path = fullfile(preprocessed.path, config.preprocess.folderFileName); % Adds Preprocessed Functions to path

if ~isfolder(preprocessed.path)
    mkdir(preprocessed.rhs_path, config.preprocess.folderFileName)
end

preprocessed.SwitchingFunctions_path = fullfile(preprocessed.path, config.preprocess.SwitchingFunctionsName); % Build path for switching functions
if ~isfolder(preprocessed.SwitchingFunctions_path)
    mkdir(preprocessed.path, config.preprocess.SwitchingFunctionsName);
end
addpath(genpath(preprocessed.path));

% export rhs
filepath_rhs = fullfile(preprocessed.path, strcat(string(preprocessed.rhs{2,1}), '.m'));
%tempFile = fopen(filepath_rhs, 'w');
%fprintf(tempFile, preprocessed.rhs{3,1}.tree2str);% funktioniert nicht
writelines(preprocessed.rhs{3,1}.tree2str, filepath_rhs)
%fclose(tempFile);



if ~isempty(preprocessed.fcn)
    % export other functions in rhs
    l = size(preprocessed.fcn, 2);
    for i = 1:l
        filename = preprocessed.fcn{2,i}; 
        filepath = fullfile(preprocessed.path, strcat(string(filename), '.m'));
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

data.caseCtrlif = 0; 








% create closure
datahandle = makeClosure(data);

end























