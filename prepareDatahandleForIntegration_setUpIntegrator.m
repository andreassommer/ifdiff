function prepareDatahandleForIntegration_setUpIntegrator(datahandle, varargin)
%PREPAREDATAHANDLEFORINTEGRATION_SETUPINTEGRATOR    Set function handles and optional arguments for integration.
%   Store function handles in the datahandle:
%   - The preprocessed RHS function
%   - The OutputFcn called after each successful integration step to monitor switches
%   Set optional arguments or provide defaults for integration:
%   - ODE Options (in particular AbsTol and RelTol)
%   - The integrator to be used (as char array or function handle)
%
%   INPUT
%   datahandle : handle to data where the settings will be written to
%   varargin : cell array which may contain optional arguments as key-value pairs
%
%   OUTPUT
%   [none]


data = datahandle.getData();

% Default values
data.integratorSettings.options = odeset('AbsTol', 1e-12, 'RelTol', 1e-4);
data.integratorSettings.numericIntegrator = @ode45;

% Optional arguments
if hasOption(varargin, 'options')
    data.integratorSettings.options = getOption(varargin, 'options');
else
    fprintf( ...
        'INFO: Parameter ''options'' not specified. Using default value: AbsTol=%.2e, RelTol=%.2e\n', ...
        data.integratorSettings.options.AbsTol, data.integratorSettings.options.RelTol);
end

if hasOption(varargin, 'integrator')
    integrator = getOption(varargin, 'integrator');
    % Integrator may be passed as function handle or char array.
    if ~isa(integrator, 'function_handle')
        try
            integrator = str2func(integrator);
        catch ME
            if strcmp(ME.identifier, 'MATLAB:string:MustBeStringScalarOrCharacterVector')
                msg = sprintf( ...
                    ['Incorrect type for parameter ''integrator'': ' ...
                    'Expected text scalar or function handle but got %s instead.\n'], class(integrator));
                causeException = MException('IFDIFF:prepareDatahandle:incorrectParameterType', msg);
                ME = addCause(ME, causeException);
            end
            rethrow(ME);
        end
    end
    data.integratorSettings.numericIntegrator = integrator;
else
    fprintf( ...
        'INFO: Parameter ''integrator'' not specified. Using default value: %s\n', ...
        func2str(data.integratorSettings.numericIntegrator));
end


% OutputFcn which will be called after each successful integration step to monitor switches.
outputFunction =  @(t, y, flag) analyseSignature(t, y, flag, datahandle);
data.integratorSettings.optionsForcedBranching = odeset(data.integratorSettings.options, 'OutputFcn', outputFunction);

% Function handle for the preprocessed RHS function.
data.integratorSettings.preprocessed_rhs = str2func(data.mtreeplus{2,1});

datahandle.setData(data);
end