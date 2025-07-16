function dx = LotkaVolterraRHS(~,x,p)
    alpha = p(1); % 0.2
    beta = p(2);  % 0.01
    gamma = p(3); % 0.001
    delta = p(4); % 0.1
    dx = zeros(2,1);
    if x(1) > 60
        dx(1) = alpha * x(1) - beta * x(1) * x(2);
        dx(2) = 5 * gamma * x(1) * x(2) - 0.2 * delta * x(2);
    else
        dx(1) = alpha * x(1) - beta * x(1) * x(2);
        dx(2) = gamma * x(1) * x(2) - delta * x(2);
    end
end