function preModifyDataHandle(datahandle, tspan, initialvalues, parameters)
% by that one secures that the integration with SWP_detection (Switching Point
% Detection) can be repeated
% set first signature of rhs
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

% SWP_detection: 'switching point detection'
% create .SWP_detection field of data
data.SWP_detection   = preModifyDataHandle_SWP_detection(tspan, initialvalues, parameters);
data.forcedBranching = preModifyDataHandle_forcedBranching();

data.getSignature = preModifyDataHandle_getSignature(); 
data.computeSensitivity = preModifyDataHandle_computeSensitivity();

% set first switching point signature w.r.t. the initialvalues.
% solveODE or extendODE require that the first signature has already been
% calculated and stored in .switch_cond
datahandle.setData(data);

% object now ready for the first integration and for the switching point detection/ handling
end




