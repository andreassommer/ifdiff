function res = F_noFil(x, mu_rel, epsilon, F_s, k, delta)
if mu_rel <= -epsilon
    res = F_s / (1 - delta * mu_rel);
else
    if mu_rel >= epsilon
        res = (-F_s) / (1 + delta * mu_rel);
    else
        if k*x(1) <= -F_s
            res = F_s;
        else
            if k*x(1) >= F_s
                res = F_s;
            else
                res = k*x(1);
            end
        end
    end
end
end

