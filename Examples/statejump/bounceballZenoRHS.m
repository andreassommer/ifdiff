function dx = bounceballZenoRHS(~, x, p)
% basic bouncing ball with Zeno's phenomenon treatment. It loses energy on each bounce, but
% not by air friction.
% p = [g, gamma, eByMassMin]
% See bounceballRHS for explanation on the basic bouncing ball.

    % Energy computation: ePot = m*g*h, eKin = (1/2)*m*v^2. leaving out the mass since we
    % divide by it afterward.
    ePot = p(1) * x(1);
    eKin = (1/2) * x(2)^2;
    if ePot + eKin < p(3)
        dx = [0; 0];
    else
        dx = [x(2); -p(1)];
        ifdiff_jumpif(x(1), -1, [eps(1)*(1/p(1)) * p(2)^2*x(2)^2 - x(1); -(1+p(2))*x(2)]);
    end
end
