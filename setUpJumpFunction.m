function handle = setUpJumpFunction(datahandle, sI)
%SETUPJUMPFUNCTION construct and export the jump function for a switching index

config = makeConfig();
data = datahandle.getData();

% Since the construction of jump functions almost exactly mirrors the construction of switching
% functions, we can just reuse many functions.
jumpFcn = setUpSwitchingFunction_assembleStruct( ...
    datahandle, ...
    sI, ...
    config.jump.jumpFunctionNamePrefix, ...
    data.paths.preprocessed_jumpFunction);

% Assign the function and ctrlif indices to the functions in which they appear
jumpFcn = setUpSwitchingFunction_getFunctionIndices_wrapper(jumpFcn);
jumpFcn = setUpSwitchingFunction_getCtrlifIndices(jumpFcn);

% copy the mtree for modifying, change name of the RHS (e.g. from preprocessed_rhs -> sw_preprocessed_rhs)
% helper functions will be copied and renamed later only if they are actually needed
jumpFcn.mtreeobj_switchingFcn = jumpFcn.mtreeobj(:,1);
jumpFcn.mtreeobj_switchingFcn{3,1} = mtree_changeFcnName(jumpFcn.mtreeobj_switchingFcn{3,1}, jumpFcn.rhs_name);
jumpFcn.mtreeobj_switchingFcn{1,1} = jumpFcn.rhs_name;

% remove ctrlifs before sI and replace them with their corresponding truepart/falsepart
for i = 1 : jumpFcn.sI
    function_index_i = jumpFcn.function_index_t1{i};
    if function_index_i(1) == 0
        jumpFcn = setUpSwitchingFunction_replaceCtrlifByTrueOrFalse(jumpFcn, 1, i);
    else
        currentFcn = 1;
        % the ctrlif is in a helper function, we have to make a modified version of it. If the helper is called not
        % directly, but by another helper, then we have to modify that one too because of the new function name
        for j = 1:length(function_index_i)
            function_index_j = function_index_i(j);
            [jumpFcn, currentFcn] = ...
                setUpSwitchingFunction_setUpFcnCall(jumpFcn, currentFcn, function_index_j);
        end
        jumpFcn = setUpSwitchingFunction_replaceCtrlifByTrueOrFalse(jumpFcn, currentFcn, i);
    end
end

% Replace the ctrljump with a return statement
function_index_sI = jumpFcn.function_index_t1{jumpFcn.sI};
if function_index_sI(1) == 0
    % the jump function and its associated ctrlif are in the RHS
    jumpFcn = setUpJumpFunction_replaceCtrljumpByReturn(jumpFcn, 1, jumpFcn.sI);
else
    currentFcn = 1;
    % again, we may need to modify intermediate function calls. This time, they also need to have their return
    % statements modified
    for j = 1:length(function_index_sI)
        function_index_j = function_index_sI(j);
        [jumpFcn, nextFcn] = setUpSwitchingFunction_setUpFcnCall(jumpFcn, currentFcn, function_index_j);
        jumpFcn            = setUpSwitchingFunction_setFcnCallAsReturnValue(jumpFcn, currentFcn, function_index_j);
        currentFcn = nextFcn;
    end
    jumpFcn = setUpJumpFunction_replaceCtrljumpByReturn(jumpFcn, currentFcn, jumpFcn.sI);
end

% export Switching Functions as source code and return the handle to the main switching function
handle = setUpSwitchingFunction_ExportFunctions(jumpFcn);
end