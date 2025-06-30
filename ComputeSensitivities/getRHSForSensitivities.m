function rhs = getRHSForSensitivities(datahandle)
%

data = datahandle.getData();
if isempty(data.sliding.convexification.alpha)
    rhs = data.integratorSettings.preprocessed_rhs;
else
    rhs = @FilippovRHSFromSlidingHistory;
end

end