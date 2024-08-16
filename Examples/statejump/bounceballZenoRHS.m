function dx = bounceballZenoRHS(~, x, p)
% basic bouncing ball with Zeno's phenomenon treatment. It loses energy on each bounce, but
% not by air friction.
% p = [g, gamma, eByMassMin]
% with gravitational force g (in m/s^2), bounce restitution constant gamma, and minimum
% energy/mass eByMassMin below which the ball is treated as lying flat.
% After each bounce, the new velocity `vNew` is `-gamma * vOld`.
% Once the ball's total energy divided by its mass dips below eMin, the ball lies flat.
% x = [h; v] height and velocity of the ball.

    % Energy computation: ePot = m*g*h, eKin = (1/2)*m*v^2. leaving out the mass since we
    % divide by it afterward.
    ePot = p(1) * x(1);
    eKin = (1/2) * x(2)^2;
    if ePot + eKin < p(3)
        dx = [0; 0];
    else
        dx = [x(2); -p(1)];
        % state jump: if the height goes from positive to negative, jump to [+eps, -v].
        % The eps is to avoid another immediate switching event being detected.
        ifdiff_jumpif(x(1), -1, [-eps(1)*x(2) - x(1); -(1+p(2))*x(2)]);
    end
end
