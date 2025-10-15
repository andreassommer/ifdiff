function dx = bounceball_rhs(t, x, p)
    % t:    time
    % x:    state
    % p:    parameter vector
    %       p(1) is a bounce-parameter (currently not in use!)
    %       p(2) is object's mass
    %       p(3) is gravitational force
    %    
    % This example implements a simple model of a ball bouncing in
    % one dimension, i.e., horizontally. 
    % To avoid state-jumps, we allow the position x(1) of the ball 
    % to be negative. After integration, one should take the absolute
    % value of x(1).

    dx  = zeros(2,1);
    m   = p(2);
    
    % RHS logic
    if x(1)>=0
        g =  exp(2*t)*p(3);
    else
        g = -exp(2*t)*p(3);
    end

    dx(1) = x(2);
    dx(2) = -g/m;

end