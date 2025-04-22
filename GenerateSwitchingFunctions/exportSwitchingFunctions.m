function exportSwitchingFunctions(exportMtreeArray, writePath, functionName, signatureString)
%EXPORTSWITCHINGFUNCTIONS(exportMtreeArray, writePath, functionName, signatureString)
%
%Export all individual functions related to a switching/jump function to source code files.
%
%INPUT:
%   exportMtreeArray - Mtrees of individual functions to be exported.
%       1xN cell array of mtreeplus
%
%   writePath - Absolute path to directory in which the source code of functions will be placed.
%       char array
%
%   functionName - Unique name of the switching/jump function. Used to generate the filenames for individual functions.
%       char array
%
%   signatureString - String representation of the jump/switching function's signature.
%   Will be added as a header comment to the files to make detecting hash collisions later possible.
%       char array
%
%OUTPUT:
%   Files for the functions will be created and written to disk.

for idxExportMtree = 1:length(exportMtreeArray)
    % Create absolute path for new file
    filepath = [getExportFunctionName(functionName, idxExportMtree), '.m'];
    filepath = fullfile(writePath, filepath);
    file = fopen(filepath, 'w');
    % Add a signature header as comment and dump the mtree
    fprintf(file, '%%%s\n%s\n', signatureString, exportMtreeArray{idxExportMtree}.tree2str);
    fclose(file);
end
end
