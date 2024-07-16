function config_out = makeConfig()
% store all character strings within on function. 
% Character string probably are called within several functions. Due to
% this function all of these can be changed over overseen easily 


% increase performance
persistent config

if ~isempty(config)
    config_out = config;
    return
end




% config not yet initialized, so build it

% Name of the datahandle argument which is added to the argument list of
% - the preprocessed RHS function (see: preprocess_rhsAddDatahandleToInput)
% - preprocessed helper functions (see: preprocess_editFunctionHead)
% Also used to construct function calls in an mtree for
% - ctrlifs (see: preprocess_setUpCtrlif)
% - helper functions (see: preprocess_adjustFcnCallsRhs)
config.datahandleArgumentName = 'datahandle';
% Name of the function index argument which is added to the argument list of
% - preprocessed helper functions (see: preprocess_editFunctionHead)
% Also used to construct function calls in an mtree for
% - ctrlifs (see: preprocess_setUpCtrlif)
% - the function index update function (see: preprocess_adjustFcnCallsRhs)
config.function_indexArgumentName = 'function_index';
% Prefix used for generating the name of the variable which stores the updated function index for
% a helper function call (see: preprocess_adjustFcnCallsRhs)
config.function_indexVariablePrefix = 'function_index_for_call_';
% Name of the function used to update the function index before calling a helper function. Used to
% - construct function index update function calls in an mtree (see: preprocess_adjustFcnCallsRhs)
% - find function indices in an mtree (see: setUpSwitchingFunction_getFunctionIndices)
% WARNING: Ensure that the name of the update function matches this parameter.
config.function_indexUpdateFunctionName = 'setFunctionIndex';

% Chunk size used for preallocation when updating the signature in a ctrlif to avoid frequent resizing of arrays
% (see: ctrlif_getSignaturePreallocation)
config.ctrlif_signaturePreallocationChunkSize = 30;

config.caseCtrlif.default = 0;
config.caseCtrlif.forcedBranching = 1;
config.caseCtrlif.extendODEuntilSwitch = 2;
config.caseCtrlif.getSignature = 3;
config.caseCtrlif.getSignatureChange = 4;
config.caseCtrlif.computeSensitivities = 5;

% Name of the output of generated switching functions. Used as the variable name for the output of
% - ctrlifs (see: setUpSwitchingFunction_replaceCtrlifByReturn)
% - helper functions (see: setUpSwitchingFunction_setFcnCallAsReturnValue)
% when building a switching function in an mtree.
config.switchingFunctionOutputName = 'switching_value';
% Prefix used to construct the name of a generated switching function (see: setUpSwitchingFunction_newName)
config.switchingFunctionNamePrefix = 'sw_';

% Name of the ctrlif function. Used in multiple places for mtree manipulation.
config.ctrlif.functionName = 'ctrlif';
% Name of the variable that will store the output of a ctrlif call (see: mtree_replaceIfByCtrlif).
config.ctrlif.outputName = 'condition_value';

% Infix used to construct the name of a variable that will hold the output/argument of a function call
% that induces control flow (e.g. helper functions, min, max, abs, sign)
% Used when extracting a function call into a new line (see: mtree_createSeparateFunctionCallInNewLine)
config.functionCallOutputNameInfix = '_output_for_call_';
config.functionCallArgumentNameInfix = '_arg_for_call_';
config.functionCallArgument1NameInfix = '_arg1_for_call_';
config.functionCallArgument2NameInfix = '_arg2_for_call_';

% Prefix for variables used when transforming an abs/max/min/sign function call.
config.absCallPrefix = 'abs';
config.maxCallPrefix = 'max';
config.minCallPrefix = 'min';
config.signCallPrefix = 'sign';

% Naming of preprocessed functions and directories where they are stored.
config.preprocessedRhsNamePrefix = 'rhs_preprocessed_';
config.preprocessedFunctionNamePrefix = 'preprocessed_';
config.preprocessedFunctionsDirectoryName = 'PreprocessedFunctions';
config.switchingFunctionsDirectoryName = 'SwitchingFunctions';

% Used to find certain types of nodes in an mtree.
config.mtree_rIndex_function.Suffix_expr   = '_expr';
config.mtree_rIndex_function.Suffix_call   = '_call';
config.mtree_rIndex_function.Suffix_equals = '_Equals';
config.mtree_rIndex_function.Suffix_out    = '_Out';
config.mtree_rIndex_function.Suffix_fname  = '_Fname';

% Condition will be ignored by IFDIFF if it contains at least one of the following strings:
config.forbiddenConditionStrings = {'nargin', 'nargout', 'isempty', 'isnan', 'isnumeric'};



config_out = config;

end

