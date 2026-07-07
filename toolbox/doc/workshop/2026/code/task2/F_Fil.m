function res = F_fil(x, v_rel, epsilon, F_s, k, delta)
if v_rel <= 0
    res = F_s / (1 - delta * v_rel);
end
if v_rel > 0
    res = -F_s / (1 + delta * v_rel);
end
end

