function extendODE_t2_to_tend_with_SWP_detection(datahandle)
% extend solution object from t2 ongoing until either the end of the time horizon or the next switch

data = datahandle.getData();

ctrlif_setForcedBranchingSignature(datahandle, data.SWP_detection.t2, data.SWP_detection.x2{2});
z = odextend(...
    data.SWP_detection.solution_until_t2,...
    @(t, y) data.integratorSettings.preprocessed_rhs(datahandle, t, y, data.SWP_detection.parameters), ...
    data.SWP_detection.tspan(2), ...
    data.SWP_detection.x2{2}, ... % conveniently, if this is identical to sol.y(end), odextend does not add a time point
    data.integratorSettings.optionsForcedBranching);

data = datahandle.getData();
% if a jump happened, shift t- to the left, so the solution is cadlag
if ~isempty(data.SWP_detection.jumpFunction{end})
    t2MinusIndex = length(data.SWP_detection.solution_until_t2.x);
    t2 = z.x(t2MinusIndex);
    % eps is the difference to the next-larger number. in most cases, this is also the difference to the next-smallest.
    % only for powers of two do we need to use eps(t2-eps(t2)). Also appears to work for 0 and denormal numbers
    t2 = t2 - eps(t2-eps(t2));
    z.x(t2MinusIndex) = t2;
end
data.SWP_detection.solution_until_t3 = z;

% get timepoints: t_i, t_iplus1
data.SWP_detection.t1 = data.SWP_detection.solution_until_t3.x(end-1);
data.SWP_detection.t3 = data.SWP_detection.solution_until_t3.x(end);

datahandle.setData(data);
end