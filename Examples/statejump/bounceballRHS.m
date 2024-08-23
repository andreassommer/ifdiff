function dx = bounceballRHS(~, x, p)
% basic bouncing ball. It loses energy on each bounce, but not by air friction. There is no
% solution to Zeno's phenomenon when the ball is very low, just don't integrate that far.
% p = [g, gamma]
% with gravitational force g (in m/s^2) and bounce restitution constant gamma.
% After each bounce, the new velocity `vNew` is `-gamma * vOld`
% x = [h; v] height and velocity of the ball.

% Starting with [h, v](t0) = [0, v0], we can compute that the time of the next ground contact is 2*v0/g and
% the velocity there is -v0.
% When the ball bounces again with [h, v](t0:=ts) = [0, gamma*v0], the next ground contact occurs at 2*gamma*v0/g.
% Continuing this, the total distance traveled after the k-th bounce is
% (1 + gamma + gamma^2 + ... + gamma^(k-1)) * 2*v0/g, converging to (1/(1-gamma))*2*v0/g as the number of bounces goes
% to infinity. The other way round: within the time horizon (1/(1-gamma))*2*v0/g, there are infinitely many bounces.

    dx = [x(2); -p(1)];
    % state jump: if the height goes from positive to negative, jump to [+eps, -v].
    % The eps is to avoid another immediate switching event being detected.
    % Refinement 1: set h+ = eps*v+^2. setting h+ to a value other than 0 kind of ruins that elegant
    % geometric series, but setting h+ to a multiple of v+^2 lets us pull v+ out of the square root
    % and get a geometric series after all.
    % Refinement 2: instead of eps*v+^2, set h+ to (1/g)*eps*v+^2 because the error in v+ depends on
    % g. this also leads to some nice canceling out in the derivation of the zeno limit
    ifdiff_jumpif(x(1), -1, [eps(1)*(1/p(1)) * p(2)^2*x(2)^2 - x(1); -(1+p(2))*x(2)]);
end
