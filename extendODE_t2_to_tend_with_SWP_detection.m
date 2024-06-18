function extendODE_t2_to_tend_with_SWP_detection(datahandle)
% extend solution object from t2 ongoing until the next switch occurs
% signature saved in .SWP_detection.
%
% Requires .solution_until_t2


data = datahandle.getData();


t = data.SWP_detection.solution_until_t2.x(end);
x = deval(data.SWP_detection.solution_until_t2,  data.SWP_detection.solution_until_t2.x(end)); 

ctrlif_setForcedBranchingSignature(datahandle, t, x);

% in the odeoptions is contained the datahandle, therefor it es essential
% to understand, that datahandle is not a local variable here.
if isempty(data.integratorSettings.filippov_rhs)
    rhs = @(t, y) data.integratorSettings.preprocessed_rhs(datahandle, t, y, data.SWP_detection.parameters);
else
    rhs = @(t, y) data.integratorSettings.filippov_rhs(datahandle, t, y, data.SWP_detection.parameters);
end
z = odextend(...
    data.SWP_detection.solution_until_t2,...
    rhs, ...
    data.SWP_detection.tspan(2),...
    [], ...
    data.integratorSettings.optionsForcedBranching);
data = datahandle.getData();
data.SWP_detection.solution_until_t3 = z;

% get timepoints: t_i, t_iplus1
data.SWP_detection.t1 = data.SWP_detection.solution_until_t3.x(end-1);
data.SWP_detection.t3 = data.SWP_detection.solution_until_t3.x(end);


datahandle.setData(data);



end
