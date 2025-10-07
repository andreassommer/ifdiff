function dx = canonicalExampleRHS_extended(t,x,p)
dx = zeros(2,1);
%dx(1) = 0.01 * t.^2  +  x(2).^2;
dx(1) = 0.01*t + x(2); 
dx(2) = 0; 

% a = 1:10:41; 
% dx(2) = aNiceFunction(x,t,p, a, dx(2)); 

% dx(2) = checkFeasibility(...
%     x, t, p, ...      % standardinput (in general for switchingpoint detection not necessarly required) 
%     2, 3, ...         % intervalboarders
%     1, dx(2), 1);         % 


a = 1:10:101; 

dx(2) = aNiceFunction(x,t,p,a, dx(2)); 

a = a + 5000; 
dx(2) = aNiceFunction(x,t,p,a, dx(2)); 

a = a + 5000; 
dx(2) = aNiceFunction(x,t,p,a, dx(2)); 

a = a + 5000; 
dx(2) = aNiceFunction(x,t,p,a, dx(2)); 



end

