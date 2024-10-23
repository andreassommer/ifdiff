function switchingFcnHandle = createSwitchingFcnFromSignature(signature, mtrees, rhs_name, path)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.
%   Writes the function to a file based on a hash computed from the signature and returns function handle.
%
%   INPUT
%   signature : SwitchingFunctionSignature belonging to the switching function that shall be created
%   mtrees : 1x? cell array containing mtrees of RHS and helper functions
%   rhs_name : name of the rhs function
%   path : directory which will contain the exported switching function file


% Start building the switching function from the mtree of the RHS.
name = createSwitchingFcnNewName(signature.hash, rhs_name);

% Change name of the switching function in mtree.
mtrees{1} = mtree_changeFcnName(mtrees{1}, name);

% All ctrlifs before the ctrlif whose condition value has changed are replaced by their true/false part
num_ctrlif = length(signature.switch_cond);
for i=1:num_ctrlif-1
    % Check if the ctrlif was called in the RHS or a helper function
    function_index = signature.function_index{i};
    if function_index(1) == 0
        mtrees{1} = replaceCtrlifByTrueOrFalse(signature.ctrlif_index(i), signature.switch_cond(i), mtrees{1});
    else
        error('Helper functions not implemented yet!');
    end
end

% Replace the last ctrlif (i.e. the one whose condition value has changed) by a return
if signature.function_index{end} == 0
    mtrees{1} = replaceCtrlifByReturn(signature.ctrlif_index(end), mtrees{1});
else
    error('Helper functions not implemented yet!');
end

% Remove variables that do not contribute to the return value for all functions
for i=1:length(mtrees)
    sortedMtree = mtreeplus(mtrees{i}.tree2str);
    mtrees{i} = deleteUnusedParameters(sortedMtree);
end

% Export the created mtrees to files
for i=1:length(mtrees)
    if i == 1
        suffix = '';
    else
        suffix = ['_', i];
    end

    filename = fullfile(path, [name, suffix, '.m']);
    file = fopen(filename, 'w');
    fprintf(file, '%s\n', mtrees{i}.tree2str);
    fclose(file);
end

switchingFcnHandle = str2func(name);

end

