function extendODE_t2_to_tend_with_SWP_detection(datahandle)
% extend solution object from t2 ongoing until either the end of the time horizon or the next switch

data = datahandle.getData();

ctrlif_setForcedBranchingSignature(datahandle, data.SWP_detection.t2, data.SWP_detection.x2{2});
z = odextend(...
    data.SWP_detection.solution_until_t2,...
    @(t, y) data.integratorSettings.preprocessed_rhs(datahandle, t, y, data.SWP_detection.parameters), ...
    data.SWP_detection.tspan(2),...
    data.SWP_detection.x2{2}, ... conveniently, if this is identical to sol.y(end), odextend does not add a time point
    data.integratorSettings.optionsForcedBranching);

data = datahandle.getData();
% if a jump happened, shift t- by two eps to the left, so the solution is cadlag
if ~isempty(data.SWP_detection.jumpFunction{end})
    t2Index = length(data.SWP_detection.solution_until_t2.x);
    t2 = z.x(t2Index);
    z.x(t2Index) = t2 - 2*eps(t2);
end
data.SWP_detection.solution_until_t3 = z;

% get timepoints: t_i, t_iplus1
data.SWP_detection.t1 = data.SWP_detection.solution_until_t3.x(end-1);
data.SWP_detection.t3 = data.SWP_detection.solution_until_t3.x(end);

datahandle.setData(data);
end