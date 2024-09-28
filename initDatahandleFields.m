function initDatahandleFields(datahandle, tspan, initialvalues, parameters)
% Initialize the fields of the datahandle to initial values for starting a new integration run.
%
% INPUT:
% datahandle:       datahandle from prepareDatahandleForIntegration
% tspan:            integration borders, as choosen from user
% initialvalues:    initialvalues, as choosen from user
% parameters:       parameters, as choosen from user
%
% OUTPUT:
% datahandle ready for integration

data = datahandle.getData();

data.SWP_detection      = initDatahandleFields_SWP_detection(tspan, initialvalues, parameters);
data.forcedBranching    = initDatahandleFields_forcedBranching();
data.getSignature       = initDatahandleFields_getSignature(); 
data.computeSensitivity = initDatahandleFields_computeSensitivity();

datahandle.setData(data);

% object now ready for the first integration and for the switching point detection/ handling
end




