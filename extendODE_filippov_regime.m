function extendODE_filippov_regime(datahandle)
% Extends the solution object from t2 ongoing until the end of the time span is
% reached or the Filippov mode is left. The solution info is written back
% to the fields for time t2, that way we can continue the integration with
% 'extendODE_t2_to_tend_with_SWP_detection.m'.

data = datahandle.getData();

t = data.SWP_detection.solution_until_t2.x(end);
x = deval(data.SWP_detection.solution_until_t2,  data.SWP_detection.solution_until_t2.x(end)); 
ctrlif_setForcedBranchingSignature(datahandle, t, x);

rhs = @(t, y) data.sliding.filippov_rhs(datahandle, t, y, data.SWP_detection.parameters);
z = odextend(...
    data.SWP_detection.solution_until_t2,... % sol
    rhs, ...                            % rhs
    data.SWP_detection.tspan(2), ...    % tfinal
    data.SWP_detection.x2{2}, ...       % initial value
    data.integratorSettings.optionsForcedBranching); % options

% we write the solution to t2 so that we can continue from there. this
% doesn't interfere with checking for changed signatures
data = datahandle.getData();
data.SWP_detection.solution_until_t2 = z;
data.SWP_detection.t2 = data.SWP_detection.solution_until_t2.x(end);

% clear filippov data, serves also as indicator for inactive filippov mode
% (this is prone to errors, come up with a better solution)
extendODE_filippov_regime_cleanup(data.sliding);

datahandle.setData(data);

end