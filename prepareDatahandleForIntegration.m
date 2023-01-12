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


% set up the function handles for the right hand side and the output
% function (function that stops the integration process if a switch is
% detected)
if isempty(varargin)
    prepareDatahandleForIntegration_setUpFunctionHandles(datahandle);
else
    prepareDatahandleForIntegration_setUpFunctionHandles(datahandle, varargin);
end

% check whether rhs has parameter. 
% if not just add "~" to the rhs as third arguemnt (this is not done automatically) 
prepareDatahandleForIntegration_checkRhs(datahandle) 

% store ode options in the datahandle: either as default or the ones given by the user
if isempty(varargin)
    prepareDatahandleForIntegration_setUpOdeOptions(datahandle);
else
    prepareDatahandleForIntegration_setUpOdeOptions(datahandle, varargin);
end


end




























