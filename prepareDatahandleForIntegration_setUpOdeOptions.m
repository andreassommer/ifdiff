function prepareDatahandleForIntegration_setUpOdeOptions(datahandle, varargin)
% store options that are used for the ODE integrator.
% .odenormaloptions: integration without switching point detection. Is used
% when the switch has been determined to integrated until the switch. 
% 
% .odeodefulloptions: options used with the switching point detection. It
% contains the very important function 'output function' (analyseSignature)
% that is called after each successful integration step in order to compare
% the sign of the switching function at t_i with t_i+1 and analyseSignature
% implements the forced-branching method. 

data = datahandle.getData();


if isempty(varargin)
    myOptionList = {'',{}};
else 
    myOptionList = varargin{:}; 
end 


% set up the normal options
if hasOption(myOptionList, 'options')
    data.integratorSettings.options = getOption(varargin{:}, 'options');
else
    % defautl values
    data.integratorSettings.options = odeset( 'AbsTol', 1e-12, 'RelTol', 1e-3);
end

% set up the full ode options
data.integratorSettings.optionsForcedBranching = odeset(data.integratorSettings.options, 'OutputFcn', @(t, y, flag) analyseSignature(t, y, flag, datahandle));

datahandle.setData(data);
end





























