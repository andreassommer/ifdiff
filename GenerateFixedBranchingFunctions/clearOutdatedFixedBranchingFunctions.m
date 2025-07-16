function clearOutdatedFixedBranchingFunctions(datahandle)
%CLEAROUTDATEDFIXEDBRANCHINGFUNCTIONS(datahandle)
%
%Remove switching/jump/model functions that are older than the original RHS source file.
%Not removing outdated functions after changing a RHS can lead to fatal errors.
%
%INPUT:
%   data.paths - Directories where switching/jump/model functions are stored.
%       struct
%
%   data.mtreeplus - Name of original and preprocessed RHS.
%       3x? cell array
%
%OUTPUT:
%   Outdated function files removed ensuring that IFDIFF generates new ones during integration.

config = makeConfig();
data = datahandle.getData();

baseDirArray = { ...
    data.paths.preprocessed_switchingFunction, ...
    data.paths.preprocessed_jumpFunction, ...
    data.paths.preprocessed_modelFunction};
filePrefixArray = { ...
    config.switchingFunctionNamePrefix, ...
    config.jump.jumpFunctionNamePrefix, ...
    config.modelFunctionNamePrefix};

originalRhsName = data.mtreeplus{1, 1};
preprocessedRhsName = data.mtreeplus{2, 1};
rhsFileDate = getRhsFileDate(originalRhsName);

for idxFuncType=1:numel(baseDirArray)
    listing = getFunctionFiles(baseDirArray{idxFuncType}, filePrefixArray{idxFuncType}, preprocessedRhsName);
    listing = getFilesOlderThanDate(listing, rhsFileDate);
    removeFiles(listing);
end
end

%% Helpers
function listing = getFunctionFiles(baseDir, filePrefix, rhsName)
listing = {};
% Regex components should not be empty or contain wildcards.
if ~isSafe(baseDir) || ~isSafe(filePrefix) || ~isSafe(rhsName)
    return
end

pathRegex = [createSwitchingFunctionName(filePrefix, rhsName, '*', []), '*.m'];
pathRegex = fullfile(baseDir, pathRegex);
listing = dir(pathRegex);
% Just in case, filter out directories.
listing = listing(~[listing.isdir]);
end

function tf = isSafe(s)
tf = ~isempty(s) & ~any(ismember(s, '*'));
end

function date = getRhsFileDate(rhsName)
rhsPath = which(rhsName);
date = dir(rhsPath).datenum;
end

function listing = getFilesOlderThanDate(listing, filedate)
dates = [listing.datenum];
listing = listing(dates < filedate);
end

function removeFiles(listing)
config = makeConfig();

names = {listing.name};
folders = {listing.folder};

nFiles = numel(names);
files = cell(1, nFiles);

for idxFile=1:nFiles
    filepath = fullfile(folders{idxFile}, names{idxFile});
    if ~contains(filepath, config.preprocessedFunctionsDirectoryName)
        fileNotInPreprocessedFolderWarning(filepath, config.preprocessedFunctionsDirectoryName);
        continue
    end
    files{idxFile} = filepath;
    printDeletionMessage(filepath);
end

deleteSafe(files);
end

function deleteSafe(files)
if isempty(files)
    return
end
% Move files to recycling bin/equivalent instead of permanently deleting for safety.
recycleState = recycle('on');
delete(files{:});
recycle(recycleState);
end

%% Warnings and Messages
function fileNotInPreprocessedFolderWarning(filepath, requiredFolder)
msg = 'Skipped deleting file with path %s, because it is not in a subdirectory of a directory named %s.\n';
id = 'IFDIFF:ClearOutdatedFunctions:FileNotInPreprocessedFolder';
warning(id, msg, filepath, requiredFolder);
end

function printDeletionMessage(filepath)
config = makeConfig();

if config.debugMode
    fprintf('DEBUG: Removing outdated function file: %s\n', filepath);
end
end
