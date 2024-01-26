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

config.datahandle          = 'datahandle';
config.function_index      = 'function_index';
config.updateFunctionIndex = 'setFunctionIndex';

% config.path = '/Users/valentinvontrotha/Desktop/Valentin_Masterarbeit_Matlab';

config.prepareDatahandleForNewFunctionCall = 'prepareDatahandleForNewFunctionCall';
config.ctrlif_updateSignature_chunk_size = 30;


config.switchingfunction.name                = '_switchingFunction';
config.switchingfunction.name_outputvariable = 'returnvalue';
config.switchingfunction.prefix_name         = 'sw';

config.newFcnCall.newVariable = 'new_value';

config.prepareDatahandleForNewFunctionCall = 'prepareDatahandleForNewFunctionCall';
config.ctrlif_updateSignature_chunk_size = 30;

config.ctrlif.ctrlif = 'ctrlif';
config.ctrlif.Out    = 'conditionValue';
config.ctrlif.Arg2   = 'true';      % default value of Arg 2 and 3 of ctrlif
config.ctrlif.Arg3   = 'false';
config.ctrlif.Arg4   = 'index';
config.ctrlif.Arg5   = 'function_index';
config.ctrlif.Arg6   = 'datahandle';

config.ctrlif.value = 'ifdiff_condition_value';
config.ctrlif.branch = 'ifdiff_condition_branch';
config.ctrlif.logical = 'ifdiff_condition_logical';



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
config.preprocess.function_index        = 'function_index';
config.preprocess.ctrlif_index_in_fcn   = 'ctrlif_index_in_fcn';
config.preprocess.function_index_in_fcn = 'function_index_in_fcn';
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

