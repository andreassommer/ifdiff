function prepareDatahandleForIntegration_setUpIntegrator(datahandle, varargin)
%PREPAREDATAHANDLEFORINTEGRATION_SETUPINTEGRATOR    Set function handles and optional arguments for integration.
%   PREPAREDATAHANDLEFORINTEGRATION_SETUPINTEGRATOR(datahandle)
%   PREPAREDATAHANDLEFORINTEGRATION_SETUPINTEGRATOR(datahandle, key1, value1, ...)
%
%   Store function handles in the datahandle:
%   - The preprocessed RHS function
%   - The OutputFcn called after each successful integration step to monitor switches
%   Set optional arguments or provide defaults for integration:
%   - ODE Options (in particular AbsTol and RelTol)
%   - The integrator to be used (as char array or function handle)
%
%   INPUT
%   datahandle : handle to data where the settings will be written to
%   varargin   : optional arguments as key-value pairs (see makeConfig.m for default values)
%       'options'    -> ODE OPTIONS struct
%       'integrator' -> text scalar or function_handle
%       'solver'     -> same as integrator (for backwards compatibility)
%
%   OUTPUT
%   [none]


data = datahandle.getData();
config = makeConfig();
optionlist = varargin;

try
    olAssertOptionlist(optionlist);
catch ME
    msg = 'Invalid option format: varargin has to be passed as key-value pairs where keys are char arrays.\n';
    causeException = MException('IFDIFF:prepareDatahandle:invalidOptionFormat', msg);
    ME = addCause(ME, causeException);
    rethrow(ME);
end

% Default values
data.integratorSettings.options = config.optionsDefault;
data.integratorSettings.numericIntegrator = config.numericIntegratorDefault;

% Optional argument: ODE Options
[optionsVal, optionlist] = olGetOption(optionlist, 'options');
if ~isempty(optionsVal)
    data.integratorSettings.options = optionsVal;
else
    fprintf( ...
        'INFO: Option ''options'' not specified. Using default value: AbsTol=%.2e, RelTol=%.2e\n', ...
        data.integratorSettings.options.AbsTol, data.integratorSettings.options.RelTol);
end

% Optional argument: Integrator
[integratorVal, optionlist] = olGetOption(optionlist, 'integrator');
% Besides 'integrator', 'solver' is also accepted as a key for backward compatibility.
if isempty(integratorVal)
    [integratorVal, optionlist] = olGetOption(optionlist, 'solver');
end

if ~isempty(integratorVal)
    % Integrator may be passed as function handle or char array.
    if ~isa(integratorVal, 'function_handle')
        try
            integratorVal = str2func(integratorVal);
        catch ME
            if strcmp(ME.identifier, 'MATLAB:string:MustBeStringScalarOrCharacterVector')
                msg = sprintf([ ...
                    'Incorrect type for option ''integrator'': ' ...
                    'Expected text scalar or function handle but got %s instead.\n'], ...
                    class(integratorVal));
                causeException = MException('IFDIFF:prepareDatahandle:incorrectParameterType', msg);
                ME = addCause(ME, causeException);
            end
            rethrow(ME);
        end
    end
    data.integratorSettings.numericIntegrator = integratorVal;
else
    fprintf( ...
        'INFO: Option ''integrator'' not specified. Using default value: %s\n', ...
        func2str(data.integratorSettings.numericIntegrator));
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

datahandle.setData(data);
end
