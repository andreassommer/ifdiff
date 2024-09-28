function solveODE_firstTime(datahandle)
% solve the ODE for the first time and stop the integration if a switch occurs
%
% INPUT:
% datahandle:   datahandle by prepareDatahandleForIntegration and
%               preModifyDataHandle
%
% OUTPUT:
% datahandle:   new: .solution_until_t3. ODE integrated until there occured
%               a switch or, if there was no switch,
%               until the end of the integration interval
%               and with the switching signature saved in .SWP_detection (generated in
%               analyseSignature, the output function within the ode solver

config = makeConfig();
data = datahandle.getData();

% later one uses odeextend during the switching point detection.
% Unfortunately odeextend does not work, if the ode solver object has not
% done more than one step during the integration. Therefore
% reduce max step size to ensure that the integration has
% more than one step. (When a switch occurs in the first integration step,
% than t1 refers to tspan(1) and odeextend fails.)

% initilize a counter for the number of integration steps, if it is bigger than 2 than everthing is fine
nIntegrationSteps = 1;

% get maxStep size by default
defaultMaxStep = 0.1*abs(data.SWP_detection.tspan(1)-data.SWP_detection.tspan(2));
data.integratorSettings.optionsForcedBranching.InitialStep = defaultMaxStep; 
data.caseCtrlif = config.caseCtrlif.forcedBranching;
datahandle.setData(data)
% initialisation of nIntegrationSteps s.th. the first iteration of while is executed

% get signature at t_0 and set as forced branching signature
ctrlif_setForcedBranchingSignature(datahandle, data.SWP_detection.tspan(1), data.SWP_detection.initialvalues);

% while loop as long as there are only 2 timpoints or less during the integration
% algorithm
while nIntegrationSteps <= 2
    
    % getData since the ode options may have been changed.
    data = datahandle.getData();
    
    
    % caution: .optionsForcedBranching contains analyseSignature(...,datahandle).
    % switching point detection magic is done in analyseSignature(...,datahandle).
    z = data.integratorSettings.numericIntegrator(...
        @(t, y) data.integratorSettings.preprocessed_rhs(datahandle, t, y, data.SWP_detection.parameters), ...
        data.SWP_detection.tspan,...
        data.SWP_detection.initialvalues, ...
        data.integratorSettings.optionsForcedBranching);
    
    data = datahandle.getData();
    data.SWP_detection.solution_until_t3 = z;
    
    nIntegrationSteps = length(data.SWP_detection.solution_until_t3.x);
    
    % reduce max step size if number of timepoints not high enough
    if nIntegrationSteps <= 2
        
        data.integratorSettings.optionsForcedBranching.InitialStep = data.integratorSettings.optionsForcedBranching.InitialStep/2;
        %warning('First integration step contains switch. odeextend would fail, reduce step size only for first integration step')
    end
    
    % save new MaxStep size to datahandle.
    datahandle.setData(data);    
end

% get signature
data.SWP_detection.t1 = data.SWP_detection.solution_until_t3.x(end-1);
data.SWP_detection.t3 = data.SWP_detection.solution_until_t3.x(end);

% signature matrix
data.SWP_detection.signature.function_index{1} = data.SWP_detection.function_index_t1; 
data.SWP_detection.signature.ctrlif_index{1} = data.SWP_detection.ctrlif_index_t1;
data.SWP_detection.signature.switch_cond{1} = data.SWP_detection.switch_cond_t1;
datahandle.setData(data);


end % first integraion round done, if no switch occured, .t3 = tspan(2)



















