function datahandle = prepareDatahandleForIntegration_setUpFunctionHandles(datahandle, varargin)
% Set up function handle for:
%   - rhs
%   - ode solver (function, e.g. @ode45)
%   - outputfunction (SwitchingPointDetection)
%
%
% INPUT:
% 'temporaryfilename':  the name of the file of the rhs function after
%                       the preprocessing
% 'datahandle':         data handle containing all data for the
%                       switching point detection
% 'optionlist':         a cell array of name value pairs
% 'righthandsidefunctionhandle': function handle to the rhs function
%

data = datahandle.getData();

data.integratorSettings.preprocessed_rhs = str2func(data.mtreeplus{2,1});
data.integratorSettings.filippov_rhs = [];
data.integratorSettings.filippov_ctrlif_index = [];

if isempty(varargin)
    myOptionList = {'',{}};
else 
    myOptionList = varargin{:}; 
end 
    


% set up function handle to ode solver function
if hasOption(myOptionList, 'solver')
    data.integratorSettings.numericIntegrator = str2func(getOption(varargin{:}, 'solver'));
    % set default: ode15s
else
    data.integratorSettings.numericIntegrator = @ode15s;
end


datahandle.setData(data);
end












