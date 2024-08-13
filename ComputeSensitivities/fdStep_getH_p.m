function h_p = fdStep_getH_p(fdStep, p)
%FDSTEP_GETH_P Get finite difference step size for p. It can be either relative to p or absolute,
% depending on the property fdStep.p_rel
    if fdStep.p_rel
        h_p = max(fdStep.p_min, abs(p) .* fdStep.p);
    else
        h_p = fdStep.p;
    end
end

