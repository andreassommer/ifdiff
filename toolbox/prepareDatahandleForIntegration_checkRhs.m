function prepareDatahandleForIntegration_checkRhs(datahandle) 
% check whether rhs has three arguments, i.e. time, state, parameter
% the rhs is required to have a parameter, otherwise the integration will fail.
data = datahandle.getData(); 

if ~(nargin(str2func(data.mtreeplus{1,1})) == 3)
    error('Right-hand-side needs to have input structured like (time, state, parameter), i.e. (t,y,p)')
end 



end 