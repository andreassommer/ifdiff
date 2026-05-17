function dG = vdeRhs(t, G, sol, p, nDirY, fDyPartial, fDpPartial)
y = deval(sol, t);
dimy = length(y);

matrixG = reshape(G, dimy, []);
nDir = size(matrixG, 2);
nDirP = nDir - nDirY;

% State propagation applies to both sensitivities w.r.t. initial values and parameters.
matrixDG = fDyPartial(t, y, p, matrixG);

% Add source term for parameter sensitivities.
if nDirP > 0
    matrixDG(:, nDirY+1:end) = matrixDG(:, nDirY+1:end) + fDpPartial(t, y, p);
end

dG = matrixDG(:);
end
