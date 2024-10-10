function config_out = makeConfig()
%MAKECONFIG Retrieve a struct containing various constants used to configure the behavior of IFDIFF.
%   Modify this function to adjust the settings to your needs.
%
%   INPUT
%   [none]
%
%   OUTPUT
%   config_out : struct array containing the constants


% Only generate the config once and reuse on subsequent calls to improve performance.
persistent config

if ~isempty(config)
    config_out = config;
    return
end


% ============================== USER CONFIGURATION ==============================
% NOTE: These values may be adjusted depending on the problem you're trying to solve.

% Chunk size used for preallocation when updating the signature in a ctrlif to avoid frequent resizing of arrays.
config.ctrlif_signaturePreallocationChunkSize = 30;


% ============================= NAMING and INTERNALS =============================
% WARNING: Do NOT touch if you don't know what you're doing!

% Default values for prepareDatahandle arguments.
config.optionsDefault = odeset('AbsTol', 1e-12, 'RelTol', 1e-4);
config.numericIntegratorDefault = @ode45;

% Names of IFDIFF related arguments which are added to preprocessed functions.
config.datahandleArgumentName     = 'datahandle';
config.function_indexArgumentName = 'function_index';

% Names related to passing the correct function index to a preprocessed helper function call.
config.function_indexVariablePrefix     = 'function_index_for_call_';
config.function_indexUpdateFunctionName = 'setFunctionIndex';

% Names related to switching functions that were automatically generated by IFDIFF.
config.switchingFunctionNamePrefix = 'sw_';
config.switchingFunctionOutputName = 'switching_value';

% Names related to the ctrlif function.
config.ctrlif.functionName = 'ctrlif';
config.ctrlif.outputName   = 'condition_value';

% Make setting the mode a ctrlif operates in more readable.
config.caseCtrlif.default              = 0;
config.caseCtrlif.forcedBranching      = 1;
config.caseCtrlif.extendODEuntilSwitch = 2;
config.caseCtrlif.getSignature         = 3;
config.caseCtrlif.getSignatureChange   = 4;
config.caseCtrlif.computeSensitivities = 5;

% Used to construct variable names when extracting function calls to separate lines.
config.functionCallOutputNameInfix    = '_output_for_call_';
config.functionCallArgumentNameInfix  = '_arg_for_call_';
config.functionCallArgument1NameInfix = '_arg1_for_call_';
config.functionCallArgument2NameInfix = '_arg2_for_call_';
% Variable name prefixes for functions that are treated in a special way by IFDIFF (abs/max/min/sign).
% User-authored helper functions that contain switches will just use the name of the function as the prefix.
config.absCallPrefix  = 'abs';
config.maxCallPrefix  = 'max';
config.minCallPrefix  = 'min';
config.signCallPrefix = 'sign';

% ignore string that lets the preprocessing ignore/skip an if-statement
config.preprocess_ignorestring = 'ifdiff::ignore';

% Naming of functions automatically generated by IFDIFF and directories where they are stored.
config.preprocessedRhsNamePrefix          = 'rhs_preprocessed_';
config.preprocessedFunctionNamePrefix     = 'preprocessed_';
config.preprocessedFunctionsDirectoryName = 'PreprocessedFunctions';
config.switchingFunctionsDirectoryName    = 'SwitchingFunctions';

% A condition will be ignored by IFDIFF if it contains at least one of the following strings:
config.forbiddenConditionStrings = {'nargin', 'nargout', 'isempty', 'isnan', 'isnumeric'};

% Used to find certain types of nodes in an mtree.
% These are derived from MATLABs internal implementation of the mtree and should not be changed!
config.mtree_rIndex_function.Suffix_expr   = '_expr';
config.mtree_rIndex_function.Suffix_call   = '_call';
config.mtree_rIndex_function.Suffix_equals = '_Equals';
config.mtree_rIndex_function.Suffix_out    = '_Out';
config.mtree_rIndex_function.Suffix_fname  = '_Fname';
% ==================================================================================


config_out = config;
end