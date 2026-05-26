function sol = solveVde(this, idxModel, tspan, initialValues, nDirY, initialDirP)
rhs = getRhsFromModelNum(this.datahandle, idxModel);
rhs = @(t, y, p) rhs(this.datahandle, t, y, p);


h = 1e-6;
fDyPartial = @(t, y, p, v) finiteDifference(@(x) rhs(t, x, p), y, h, v);
if isempty(initialDirP)
    fDpPartial = [];
else
    fDpPartial = @(t, y, p) finiteDifference(@(x) rhs(t, y, x), p, h, initialDirP);
end

rhsVde = @(t, G) vdeRhs(t, G, this.parameters, this.solution, nDirY, fDyPartial, fDpPartial);
initialValues = initialValues(:);
sol = this.integrator(rhsVde, tspan, initialValues, this.integratorOptions);
end
