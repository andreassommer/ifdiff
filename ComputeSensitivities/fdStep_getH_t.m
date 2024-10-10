function h_t = fdStep_getH_t(fdStep, t)
%FDSTEP_GETH_T Get finite difference step size for t. It can be either relative to t or absolute,
% depending on the property fdStep.t_rel
    if fdStep.t_rel
        h_t = max(fdStep.t_min, abs(t) .* fdStep.t);
    else
        h_t = fdStep.t;
    end
end

