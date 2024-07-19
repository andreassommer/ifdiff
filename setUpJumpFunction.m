function handle = setUpJumpFunction(datahandle, sI)
%SETUPJUMPFUNCTION construct and export the jump function for a switching index
% Very closely matches setUpSwitchingFunction. You may find it easier to understand that first, and then
% just compare this function for the small differences.

config = makeConfig();
data = datahandle.getData();

% Unlike in setUpSwitchingFunction, we do not need to update uniqueSwEnumeration

jumpFcn = setUpSwitchingFunction_assembleStruct( ...
    datahandle, ...
    sI, ...
    config.jump.jumpFunctionNamePrefix, ...
    data.paths.preprocessed_jumpFunction);

% remove ctrlifs up to and including sI and replace them with their corresponding truepart/falsepart
% Difference to setUpSwitchingFunction: in the latter, this loop only goes until jumpFcn.sI-1, and
% ctrlif #sI is instead replaced with a return statement.
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
            [jumpFcn, currentFcn] = setUpSwitchingFunction_setUpFcnCall(jumpFcn, currentFcn, function_index_j);
        end
        jumpFcn = setUpSwitchingFunction_replaceCtrlifByTrueOrFalse(jumpFcn, currentFcn, i);
    end
end

% Replace the ctrljump with a return statement
function_index_sI = jumpFcn.function_index_t1{jumpFcn.sI};
if function_index_sI(1) == 0
    jumpFcn = setUpJumpFunction_replaceCtrljumpByReturn(jumpFcn, 1, jumpFcn.sI);
else
    currentFcn = 1;
    % again, we may need to modify intermediate function calls. This time, they also need to have their return
    % statements modified
    for j = 1:length(function_index_sI)
        function_index_j = function_index_sI(j);
        [jumpFcn, nextFcn] = setUpSwitchingFunction_setUpFcnCall(jumpFcn, currentFcn, function_index_j);
        jumpFcn = setUpSwitchingFunction_setFcnCallAsReturnValue(jumpFcn, currentFcn, function_index_j);
        currentFcn = nextFcn;
    end
    jumpFcn = setUpJumpFunction_replaceCtrljumpByReturn(jumpFcn, currentFcn, jumpFcn.sI);
end

% export jump functions as source code and return the handle to the main jump function
handle = setUpSwitchingFunction_ExportFunctions(jumpFcn);
end