function t2_final = solveODE_computeSwitchingPoint_bisection(bisection)
% calculate root of switching function- bisection. 
% can calcualte root if switching function is 0 in the beginning. 
% 
% t3 is upper bound; avoid rounding errors; 
% root is calculated up to machine precision
% exact switch may be later, solution object may have small errors. 



% t -> time
% Y -> value of ODE solution (required to evaluate the switching function; i.e. switchingFunctionHandle)
% sw -> value of switchingfunction
%
% t3 -> righttimepoint
% t2 -> midTimePoint
% t1 -> lefttimepoint
%
% y2 -> leftYValue
% y2 -> midYValue
% y3 -> rightYValue
%
% sw1 -> leftswitchingfunctionvalue
% sw2 -> midswitchingfunctionvalue
% sw3 -> rightswitchingfunctionvalue



% stopping criterion: stop is interval length is closer than machine precision of matlab
% min(eps(bisection.t3), eps(bisection.t1))  represents the smallest amout
% that t3, t1 can be changed with, i.e. it may occur that 
% 'bisection.t3 - bisection.t1 > machine precision Matlab' -> true but
% 'bisection.t3 - bisection.t1 > min(eps(bisection.t3), eps(bisection.t1))' -> false
while  bisection.t3 - bisection.t1 > min(eps(bisection.t3), eps(bisection.t1)) 
        
    % compute the center point between leftTimePoint and rightTimePoint
    % and the corresponding y and switching function value
    bisection.t2  = (bisection.t3 + bisection.t1) / 2;
    bisection.y2  = deval(bisection.solution, bisection.t2);
    bisection.sw2 = bisection.switchingFunction([], bisection.t2, bisection.y2, bisection.p);
    
    
    
    if  bisection.sw2*bisection.sw1 > 0 || abs(bisection.sw1_isNotZero) + abs(bisection.sw2) + abs(bisection.sw1) == 0
        bisection.t1      = bisection.t2;
        bisection.sw1     = bisection.sw2;
    else 
        bisection.t3      = bisection.t2;
        bisection.sw3     = bisection.sw2;
    end 
    
    
    
%     % update t1, t3 with t2 resp.
%     if (bisection.sw2 > 0 && bisection.sw1 > 0) || (bisection.sw2 < 0 && bisection.sw1 < 0)
%         bisection.t1      = bisection.t2;
%         bisection.sw1     = bisection.sw2;
%         updateSuccessfull = true; 
%     elseif (bisection.sw2 > 0 && bisection.sw3 > 0) || (bisection.sw2 < 0 && bisection.sw3 < 0)
%         bisection.t3      = bisection.t2;
%         bisection.sw3     = bisection.sw2;
%         updateSuccessfull = true; 
%     elseif bisection.sw2 == 0 && bisection.sw1 ~= 0 || (bisection.sw3 == 0 && bisection.sw1 ~= 0)
%         % special stopping criterion 
%         bisection.t3 = bisection.t2;
%         break
%     elseif bisection.sw2 == 0 && bisection.sw1 == 0 && bisection.sw1_isZero
%         % 
%         bisection.t1      = bisection.t2;
%         bisection.sw1     = bisection.sw2;
%         updateSuccessfull = true; 
% %     end
%     % disp([bisection.t1 bisection.t2 bisection.t3, bisection.sw1 bisection.sw2 bisection.sw3])
%     % if non of the above conditions is satisfied, the bisection will end
%     % in an endless while loop -> error
%     % a case that should not occur
%     if updateSuccessfull == false
%         error('Switching Point bisection failed - root of switching function cannot be detected')
%     end 
end

t2_final = bisection.t3; 

end









