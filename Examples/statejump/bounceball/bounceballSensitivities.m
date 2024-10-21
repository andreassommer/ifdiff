function [Gy_t2_t1, Gp_t2_t1, Uy_t2, Up_t2] = bounceballSensitivities(g, gamma, t1, t2Minus, x2Minus, exact)
%BOUNCEBALLSENSITIVITIES Compute G and U matrices for sensitivities of the bouncing ball example
% To help in computing sensitivities for the bouncing ball example, this function
% provides intermediate matrices: given a previous switching point t1, a left-shifted
% next SWP t2Minus (just shy of the actual SWP, since our solutions are cadlag), and the
% solution value x2Minus = x(t2Minus), get the intermediate Gy and Gp between them (no updates)
% and the update matrices Uy and Up at ts2.
% You can then piece them together with the cumulative G matrices from previous SWPs.
    Gy_t_ts = @(t, ts) [1 t-ts; 0 1];
    Gp_t_ts = @(t, ts) [-(1/2)*(t-ts)^2 0; -(t-ts) 0];
    % Note: these matrices generally need x+(t_s), but we already reduced it to x- here.
    if exact
        % For the ideal case where h+(t_s) = 0
        Uy = [-gamma, 0; -(1+gamma)*g/x2Minus, -gamma];
        Up = [0 0; 0 -x2Minus];
    else
        Uy   = [
            2*eps(1)*gamma^2-gamma, (2/g)*eps(1)*gamma^2*x2Minus;
            -(1+gamma)*g/x2Minus,    -gamma
            ];
        Up   = [
            eps(1)*gamma^2*x2Minus^2/(g^2), 2*eps(1)*gamma*x2Minus/g;
            0,                             -x2Minus
            ];
    end
    Gy_t2_t1 = Gy_t_ts(t2Minus, t1);
    Gp_t2_t1 = Gp_t_ts(t2Minus, t1);
    Uy_t2 = Uy;
    Up_t2 = Up;
end