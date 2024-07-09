function dx = bounceballJumpRHS(~, x, p)
% basic bouncing ball. It loses energy on each bounce, but not by air friction. There is no
% solution to Zeno's phenomenon when the ball is very low, just don't integrate that far.
% p = [g, gamma]
% with gravitational force g (in m/s^2) and bounce restitution constant gamma.
% After each bounce, the new velocity `vNew` is `-gamma * vOld`
% x = [h; v] height and velocity of the ball.
    dx = [x(2); -p(1)];
    % state jump: if the height goes from positive to negative, jump to [+eps, -v].
    % The eps is to avoid another immediate switching event being detected.
    ifdiff_jumpif(x(1), -1, [eps(x(2)) - x(1); -p(2)*x(2)]);
end
