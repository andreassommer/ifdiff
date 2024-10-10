function h_y = fdStep_getH_y(fdStep, y)
%FDSTEP_GETH_Y Get finite difference step size for y. It can be either relative to y or absolute,
% depending on the property fdStep.y_rel
    if fdStep.y_rel
        h_y = max(fdStep.y_min, abs(y) .* fdStep.y);
    else
        h_y = fdStep.y;
    end
end

