function prepareDatahandleForIntegration_setUpIntegrator(datahandle, varargin)
%PREPAREDATAHANDLEFORINTEGRATION_SETUPINTEGRATOR(datahandle, 'key1', val1, ...)
%
%Process optional user inputs to setup integrator and its options.
%
%INPUT:
%   datahandle - Handle where the integrator and options will be stored.
%       struct
%
%   varargin - User options passed from RHS preparation call as key-value pairs.
%       func(mandatoryArgs, ..., 'key1', val1, 'key2', val2, ...)
%
%OPTIONS:
%   integrator - ODE solver to be used by IFDIFF.
%       1xN char | string scalar | function_handle
%
%   solver - Same as integrator, but kept for backward compatibility.
%       1xN char | string scalar | function_handle
%
%   options - MATLAB ODE options to be used by the integrator.
%       struct
%
%OUTPUT:
%   datahandle - With the following fields of data.integratorSettings updated:
%       struct
%
%   preprocessed_rhs - Handle to the preprocessed RHS to be integrated by IFDIFF.
%       function_handle
%
%   numericIntegrator - Handle to the integrator used by IFDIFF.
%       function_handle
%
%   options - MATLAB ODE options to be used by the integrator.
%       struct
%
%   optionsForcedBranching - MATLAB ODE options to be used when monitoring switches during integration.
%       struct (with outputFunction set to the IFDIFF analyseSignature function)
%
%See also PREPAREDATAHANDLEFORINTEGRATION.

data = datahandle.getData();
config = makeConfig();
optionlist = varargin;
try
    olAssertOptionlist(optionlist);
catch e
    throw(invalidOptionFormatError(e));
end

% Default values
data.integratorSettings.options = config.optionsDefault;
data.integratorSettings.numericIntegrator = config.numericIntegratorDefault;

% Optional argument: ODE Options
[optionsVal, optionlist] = olGetOption(optionlist, 'options');
if ~isempty(optionsVal)
    data.integratorSettings.options = optionsVal;
else
    printDefaultValue('options', data)
end

% Optional argument: Integrator
% Besides 'integrator', 'solver' is also accepted as a key for backward compatibility.
for integratorKey={'integrator', 'solver'}
    [integratorVal, optionlist] = olGetOption(optionlist, integratorKey{:});
    if ~isempty(integratorVal)
        break
    end
end

if ~isempty(integratorVal)
    data.integratorSettings.numericIntegrator = convertIntegratorToHandle(integratorVal);
else
    printDefaultValue('integrator', data);
end

% Print warning if there are unused options
if ~isempty(optionlist)
    olKeys = optionlist(1:2:end);
    msg = ['The following options were ignored: ' sprintf('''%s'' ', olKeys{:})];
    warning('IFDIFF:prepareDatahandle:unusedOptions', msg);
end

% OutputFcn which will be called after each successful integration step to monitor switches.
outputFunction =  @(t, y, flag) analyseSignature(t, y, flag, datahandle);
data.integratorSettings.optionsForcedBranching = odeset(data.integratorSettings.options, 'OutputFcn', outputFunction);

% Function handle for the preprocessed RHS function.
data.integratorSettings.preprocessed_rhs = str2func(data.mtreeplus{2,1});

% sliding fields
data.sliding.storeSlidingInfo   = false; 
% if true: convexification parameters and signatures are stored for every integration step
data.sliding.index              = [];
data.sliding.filippov_rhs       = []; 
data.sliding.ctrlif_index       = [];
data.sliding.function_index     = [];
data.sliding.alpha_last         = [];
data.sliding.convexification.t                  = [];
data.sliding.convexification.index              = [];
data.sliding.convexification.alpha              = [];
data.sliding.convexification.signature_fminus   = {};
data.sliding.convexification.signature_fplus    = {};

datahandle.setData(data);
end

%% Helpers
function integrator = convertIntegratorToHandle(integrator)
if isa(integrator, 'function_handle')
    return
end

try
    integrator = str2func(integrator);
catch e
    e = invalidIntegratorDataTypeError(e, integrator);
    throwAsCaller(e);
end
end

function printDefaultValue(key, data)
msg = 'INFO: Option ''%s'' not specified. Using default value: ';
switch key
    case 'options'
        msg = [msg, 'AbsTol=%.0e, RelTol=%.0e\n'];
        vals = {data.integratorSettings.options.AbsTol, data.integratorSettings.options.RelTol};
    case {'integrator', 'solver'}
        msg = [msg, '%s\n'];
        vals = {func2str(data.integratorSettings.numericIntegrator)};
    otherwise
        msg = [msg, 'NONE\n'];
        vals = {};
end
fprintf(msg, key, vals{:});
end

%% Exceptions
function e = invalidOptionFormatError(e)
msg = 'Invalid option format: varargin has to be passed as key-value pairs where keys are char arrays.\n';
eCause = MException('IFDIFF:Preprocessing:InvalidOptionFormat', msg);
e = addCause(e, eCause);
end

function e = invalidIntegratorDataTypeError(e, integrator)
if strcmp(e.identifier, 'MATLAB:string:MustBeStringScalarOrCharacterVector')
    msg = [ ...
        'Incorrect type for option ''integrator'': ' ...
        'Expected text scalar or function handle but got %s instead.\n'];
    eCause = MException('IFDIFF:prepareDatahandle:incorrectParameterType', msg, class(integrator));
    e = addCause(e, eCause);
end
end
