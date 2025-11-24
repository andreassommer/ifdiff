function res = F_fric(x, mu_rel, epsilon, F_s, k, delta)
    if abs(mu_rel) <= epsilon      % epsilon small (mu rel = 0 numerically)
        res = min(abs(k * x(1)), F_s) * sign(k * x(1));
    else
        res = -( (F_s * sign(mu_rel)) / (1 + delta * abs(mu_rel)) );
    end
end

