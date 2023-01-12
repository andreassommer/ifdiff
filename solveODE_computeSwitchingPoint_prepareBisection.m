function bisection = solveODE_computeSwitchingPoint_prepareBisection(datahandle, ii)
% 'solution':
% 'datahandle':
% 'switchingFunctionHandle':
% 'parameters':
% compute the values of the switching function at timeInterval and
% yValues


% t -> time
% Y -> value of ODE solution (required to evaluate the switching function; i.e. switchingFunctionHandle)
% sw -> value of switchingfunction
%
% t3 -> righttimepoint
% t2 -> midTimePoint
% t1 -> lefttimepoint
%
% Y1 -> leftYValue
% Y2 -> midYValue
% Y3 -> rightYValue
%
% sw1 -> leftswitchingfunctionvalue
% sw2 -> midswitchingfunctionvalue
% sw3 -> rightswitchingfunctionvalue

% get data required to execute switching function
data = datahandle.getData();
bisection.solution = data.SWP_detection.solution_until_t3;
bisection.p = data.SWP_detection.parameters;
bisection.switchingFunction = data.SWP_detection.switchingfunctionhandles{ii};


bisection.t0 = data.SWP_detection.tspan(1);
bisection.t1 = bisection.solution.x(end - 1);
bisection.t3 = bisection.solution.x(end);


bisection.y0 = data.SWP_detection.initialvalues;
bisection.y1 = bisection.solution.y(:,end - 1);
bisection.y3 = bisection.solution.y(:,end);


bisection.sw1 = bisection.switchingFunction([], bisection.t1, bisection.y1, bisection.p);
bisection.sw3 = bisection.switchingFunction([], bisection.t3, bisection.y3, bisection.p);





end













