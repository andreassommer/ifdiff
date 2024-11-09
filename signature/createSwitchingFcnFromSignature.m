function switchingFcnHandle = createSwitchingFcnFromSignature(signature, mtreeArray, functionNameArray, writePath)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.
%   Writes the function to a file based on a hash computed from the signature and returns function handle.
%
%   INPUT
%   signature : SwitchingFunctionSignature belonging to the switching function that shall be created
%   mtrees : 1x? cell array containing mtrees of RHS and helper functions
%   path : directory which will contain the exported switching function file


% Start building the switching function from the mtree of the RHS.
name = createSwitchingFcnNewName(signature.hash, signature.rhsName);

% Change name of the switching function in mtree.
mtreeArray{1} = mtree_changeFcnName(mtreeArray{1}, name);


% Convert a function name to an index into the mtree array;
functionNameToIndex = containers.Map(functionNameArray, num2cell(1:length(mtreeArray)));

% Keep track of which helper functions were already turned into switching functions
isMtreeModified = false(1, length(mtreeArray));
isMtreeModified(1) = true;

% Record which function indices were already handled
processedFunctionIndices = [];

% Collect information about helper function calls for an mtree
mtreeFunctionCallInfo = struct( ...
    'function_index', cell(1, length(mtreeArray)), ...
    'Expr', [], ...
    'Call', [], ...
    'Fname', [], ...
    'Arg', [] ...
    );


% All ctrlifs before the ctrlif whose condition value has changed are replaced by their true/false part
numCtrlif = length(signature.switch_cond);
for idxCtrlif = 1:numCtrlif-1
    % Always start by looking at the RHS function
    idxMtree = 1;
    % Check if the actual ctrlif was called in the RHS or a helper function
    function_index = signature.function_index{idxCtrlif};
    if function_index(1) ~= 0
        for idxFunctionIndex = 1:length(function_index)
            % Already handled that function call before, skip
            if ismember(processedFunctionIndices, function_index(idxFunctionIndex))
                % Need some way to get the name of a function from the function index
                error("Not Implemented: Need some way to get the name of a function from the function index")
                continue
            end

            % Modify the helper function call (i.e. remove function_index and change name)
            [mtreeArray{idxMtree}, oldName, newName] = modifyFunctionCall( ...
                mtreeArray{idxMtree}, ...
                function_index(idxFunctionIndex), ...
                signature.hash ...
                );
            idxMtree = functionNameToIndex(oldName);

            % If the helper function doesn't exist yet, then create it
            if ~isMtreeModified(idxMtree)
                mtreeArray(idxMtree) = createHelperSwitchingFunction(mtreeArray(idxMtree), newName);
                isMtreeModified(idxMtree) = true;
            end
            % Proceed with next function_index and corresponding caller mtree
        end
    end

    mtreeArray{idxMtree} = replaceCtrlifByTrueOrFalse( ...
        mtreeArray{idxMtree}, ...
        signature.ctrlif_index(idxCtrlif), ...
        signature.switch_cond(idxCtrlif) ...
        );
end

% Replace the last ctrlif (i.e. the one whose condition value has changed) by a return
idxMtree = 1;
function_index = signature.function_index{end};
if function_index(1) ~= 0
    error("Helper function not implemented yet!")
    % again, we may need to modify intermediate function calls. This time, they also need to have their return
    % statements modified
    for idxFunctionIndex = 1:length(function_index)
        [switchingFcn, nextFcn]      = setUpSwitchingFunction_setUpFcnCall(switchingFcn, currentFcn, function_index_j);
        [switchingFcn, fcnCallIndex] = setUpSwitchingFunction_setFcnCallAsReturnValue(...
            switchingFcn, currentFcn, function_index_j);
        % delete all code after the newly created return statement
        fcnCallRIndex                = switchingFcn.mtreeobj_switchingFcn{5,currentFcn}.Expr(fcnCallIndex);
        switchingFcn.mtreeobj_switchingFcn{3,currentFcn}.T(fcnCallRIndex, mtree_cIndex().indexNextNode) = 0;
        currentFcn = nextFcn;
    end
end
mtreeArray{idxMtree} = replaceCtrlifByReturn(mtreeArray{idxMtree}, signature.ctrlif_index(end));


% Remove variables that do not contribute to the return value for all functions
for idxCtrlif=1:length(mtreeArray)
    sortedMtree = mtreeplus(mtreeArray{idxCtrlif}.tree2str);
    mtreeArray{idxCtrlif} = deleteUnusedParameters(sortedMtree);
end

% Export the created mtrees to files
for idxCtrlif=1:length(mtreeArray)
    if idxCtrlif == 1
        suffix = '';
    else
        suffix = ['_', idxCtrlif];
    end

    filename = fullfile(writePath, [name, suffix, '.m']);
    file = fopen(filename, 'w');
    fprintf(file, '%s\n', mtreeArray{idxCtrlif}.tree2str);
    fclose(file);
end

switchingFcnHandle = str2func(name);

end

