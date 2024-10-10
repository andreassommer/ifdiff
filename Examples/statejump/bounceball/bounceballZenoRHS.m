function dx = bounceballZenoRHS(~, x, p)
% basic bouncing ball with Zeno's phenomenon treatment. It loses energy on each bounce, but
% not by air friction.
% p = [g, gamma, eByMassMin]
% See bounceballRHS for explanation on the basic bouncing ball.
% For Zeno's phenomenon, we compute the quotient energy/mass and stop bouncing once it passes below a
% threshold

    % Energy computation: ePot = m*g*h, eKin = (1/2)*m*v^2. leaving out the mass since the threshold for
    % transitioning to the motionless model is defined by e/m, so we will end up dividing by the mass anyway.
    ePot = p(1) * x(1);
    eKin = (1/2) * x(2)^2;
    e = ePot + eKin;
    if e < p(3)
        dx = [0; 0];
    else
        dx = [x(2); -p(1)];
        if p(2)^2 * e < p(3)
            ifdiff_jumpif(x(1), -1, -x);
        else
            ifdiff_jumpif(x(1), -1, [ ...
                eps(1)*(1/p(1)) * p(2)^2*x(2)^2 - x(1); ...
                -(1+p(2))*x(2) ...
            ]);
        end
    end
end
