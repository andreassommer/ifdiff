function datahandle = prepareDatahandleForIntegration(filename, varargin)
% function that gets a filename and some options and returns a datahandle
% which is needed for the integration with switching point detection.
%
%
% INPUT:
% 'filename':   the name of the file of the rhs of the ode
% 'varargin':   additional options as key-value pairs
%
% OUTPUT:
% 'datahandle': struct (over closure; makeClosure());


preprocessed = preprocess(filename);

% Prepare integration, initilize struct
datahandle = createDatahandle(preprocessed);

% Set function handles for RHS and OutputFcn and handle varargin (odeOptions, integrator).
prepareDatahandleForIntegration_setUpIntegrator(datahandle, varargin{:});

% check whether rhs has parameter.
% if not just add "~" to the rhs as third arguemnt (this is not done automatically)
prepareDatahandleForIntegration_checkRhs(datahandle)
end