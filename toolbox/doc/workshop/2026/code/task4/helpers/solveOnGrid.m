function gridSolution = solveOnGrid(solutionFunc)
TMin = 0;
TMax = 1;
alphaMin = 0;
alphaMax = 1;
nT = 5;
nAlpha = 5;

T = linspace(TMin, TMax, nT);
alpha = linspace(alphaMin, alphaMax, nAlpha);

for idxT=1:nT
    for idxAlpha=1:nAlpha
        gridSolution(idxT, idxAlpha) = solutionFunc([T(idxT), alpha(idxAlpha)]); %#ok<AGROW>
    end
end
end
