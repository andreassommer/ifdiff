function res = F_fric_fil(x, mu_rel, epsilon, F_s, k, delta)
if mu_rel <= 0
    res = F_s / (1 - delta * mu_rel);
else
    res = -F_s / (1 + delta * mu_rel);
end
end

