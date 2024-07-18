function switchingfunctionhandle = setUpSwitchingFunction(datahandle, i)
% set up and export to file the switching function corresponding to an index of an ctrlif call
%
% INPUT:
% 'mtreeobj': mtree object of the rhs function
% 'i': the index of the ctrlif call of the desired switching function
%
% OUTPUT: function handle of the corresponding switch
%
% 'switchingFunctionHandle': a function handle to the switching function that belongs to i
% We construct the switching function by stripping down the preprocessed RHS and helper functions: A switching
% point means that exactly one ctrlif changed from true to false or vice versa. Since the first argument
% (condition) of a ctrlif is always of the form `<expr> >= 0`, we can directly use <expr> as the switching function.
% We replace the ctrlif which switched by a statement returning <expr>. All ctrlifs that
% come before it are replaced with their truepart or falsepart, depending on what their signature was
% at the switching point. Finally, all code after the relevant ctrlif, and all code and helper functions
% that do not contribute to its value, are removed, and the result is exported to file(s).

switchingFcn = setUpSwitchingFunction_assembleStruct(datahandle, i);

% Assign the function and ctrlif indices to the functions in which they appear
switchingFcn = setUpSwitchingFunction_getFunctionIndices_wrapper(switchingFcn);
switchingFcn = setUpSwitchingFunction_getCtrlifIndices(switchingFcn);

% copy the mtree for modifying, change name of the RHS (e.g. from preprocessed_rhs -> sw_preprocessed_rhs)
% helper functions will be copied and renamed later, but only if they are actually needed
if isempty(switchingFcn.mtreeobj_switchingFcn)
    switchingFcn.mtreeobj_switchingFcn = switchingFcn.mtreeobj(:,1);
    switchingFcn.mtreeobj_switchingFcn{3,1} = mtree_changeFcnName(...
        switchingFcn.mtreeobj_switchingFcn{3,1}, switchingFcn.rhs_name);
    switchingFcn.mtreeobj_switchingFcn{1,1} = switchingFcn.rhs_name;
end

% remove ctrlifs before sI and replace them with their corresponding truepart/falsepart
for i = 1 : switchingFcn.sI-1
    function_index_i = switchingFcn.function_index_t1{i};
    if function_index_i(1) == 0
        switchingFcn = setUpSwitchingFunction_replaceCtrlifByTrueOrFalse(switchingFcn, 1, i);
    else
        currentFcn = 1;
        % the ctrlif is in a helper function, we have to make a modified version of it. If the helper is called not
        % directly, but by another helper, then we have to modify that one too because of the new function name
        for j = 1:length(function_index_i)
            function_index_j = function_index_i(j);
            [switchingFcn, currentFcn] = ...
                setUpSwitchingFunction_setUpFcnCall(switchingFcn, currentFcn, function_index_j);
        end
        switchingFcn = setUpSwitchingFunction_replaceCtrlifByTrueOrFalse(switchingFcn, currentFcn, i);
    end
end

% replace ctrlif #sI with a return statement
function_index_sI = switchingFcn.function_index_t1{switchingFcn.sI};
if function_index_sI(1) == 0
    switchingFcn = setUpSwitchingFunction_replaceCtrlifByReturn(switchingFcn, 1, switchingFcn.sI);
else
    currentFcn = 1;
    % again, we may need to modify intermediate function calls. This time, they also need to have their return
    % statements modified
    for j = 1:length(function_index_sI)
        function_index_j = function_index_sI(j);
        [switchingFcn, nextFcn]      = setUpSwitchingFunction_setUpFcnCall(switchingFcn, currentFcn, function_index_j);
        [switchingFcn, fcnCallIndex] = setUpSwitchingFunction_setFcnCallAsReturnValue(...
                switchingFcn, currentFcn, function_index_j);
        % delete all code after the newly created return statement
        fcnCallRIndex                = switchingFcn.mtreeobj_switchingFcn{5,currentFcn}.Expr(fcnCallIndex);
        switchingFcn.mtreeobj_switchingFcn{3,currentFcn}.T(fcnCallRIndex, mtree_cIndex().indexNextNode) = 0;
        currentFcn = nextFcn;
    end
    switchingFcn = setUpSwitchingFunction_replaceCtrlifByReturn(switchingFcn, currentFcn, switchingFcn.sI);
end

% remove unused variables (ones that do not contribute to the return value) from each function
for i = 1:size(switchingFcn.mtreeobj_switchingFcn,2)
    sortedMtree = mtreeplus(switchingFcn.mtreeobj_switchingFcn{3,i}.tree2str);
    switchingFcn.mtreeobj_switchingFcn{3,i} = deleteUnusedParameters(sortedMtree);
end

% export Switching Functions as source code and return the handle to the main switching function
switchingfunctionhandle = setUpSwitchingFunction_ExportFunctions(switchingFcn);
end