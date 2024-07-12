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

% config.path = '/Users/valentinvontrotha/Desktop/Valentin_Masterarbeit_Matlab';

config.prepareDatahandleForNewFunctionCall = 'prepareDatahandleForNewFunctionCall';
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
% Infix used to construct the name of a variable that will hold the output of a function call
% that induces control flow (e.g. helper functions, min, max, abs, sign)
% Used when extracting a function call into a new line (see: mtree_createSeparateFunctionCallInNewLine)
config.newLineFunctionCallOutputNameInfix = 'value_for_call_';

config.prepareDatahandleForNewFunctionCall = 'prepareDatahandleForNewFunctionCall';

% Name of the ctrlif function. Used in multiple places for mtree manipulation.
config.ctrlif.functionName = 'ctrlif';
% Name of the variable that will store the output of a ctrlif call (see: mtree_replaceIfByCtrlif).
config.ctrlif.outputName = 'condition_value';
config.ctrlif.Arg2   = 'true';      % default value of Arg 2 and 3 of ctrlif
config.ctrlif.Arg3   = 'false';
config.ctrlif.Arg4   = 'index';

config.sign.temp_sign_value       = 'sign_value';
config.sign.PrefixNewlineVariable = 'sign_arg';
config.sign.PrefixNewlineFcn      = 'sign_';

config.abs.temp_abs_value         = 'abs_value';
config.abs.PrefixNewlineVariable  = 'abs_arg';
config.abs.PrefixNewlineFcn       = 'abs_';

% name of the file of rhs when processed
config.preprocess.fcn_name           = 'fcn_name';
config.preprocess.temporaryfilename  = 'preprocessedRhs';
config.preprocess.ctrlif_index       = 'ctrlif_index';
config.preprocess.ctrlif_index_in_fcn   = 'ctrlif_index_in_fcn';
config.preprocess.prefix_new_fcn_call   = 'preprocessed_';
config.preprocess.rhsFirstAndLastLines_FirstLinesHardCoded = 'rhsFirstAndLastLines_lastLinesHardCoded.m';
config.preprocess.rhsFirstAndLastLines_LastLinesHardCoded = 'rhsFirstAndLastLines_firstLinesHardCoded.m';
config.preprocess.folderFileName = 'PreprocessedFunctions';
config.preprocess.SwitchingFunctionsName = 'SwitchingFunctions';
config.preprocess.rhs_name_prefix = 'preprocessed_';

config.mtree_rIndex_function.Suffix_expr   = '_expr';
config.mtree_rIndex_function.Suffix_call   = '_call';
config.mtree_rIndex_function.Suffix_equals = '_Equals';
config.mtree_rIndex_function.Suffix_out    = '_Out';
config.mtree_rIndex_function.Suffix_fname  = '_Fname';

config.forbidden_strings_in_condition = {'nargin', 'nargout', 'isempty', 'isnan', 'isnumeric'};



config_out = config;

end

