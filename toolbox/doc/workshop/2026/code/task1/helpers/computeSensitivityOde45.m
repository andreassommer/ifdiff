function sensitivity = computeSensitivityOde45(solution, t)
rhs = solution.extdata.odefun;
integrator = str2func(solution.solver);
optionsIntegrator = solution.extdata.options;
dimY = size(solution.y, 1);

optionsVde.FDstep = generateFDstep(dimY, 1, 'ht', 1e-6, 'hy', 1e-6);

vdeRhs = @(t, G) VDE_RHS_y([], solution, @(~, t, x, p) rhs(t, x), t, G, [], optionsVde);
G0 = reshape(eye(dimY), [], 1);
tspan = [solution.x(1), solution.x(end)];

solutionVde = integrator(vdeRhs, tspan, G0, optionsIntegrator);

Gy = reshape(deval(solutionVde, t), dimY, dimY, []);
for i=1:numel(t)
    sensitivity(i).t = t(i); %#ok<*AGROW>
    sensitivity(i).Gy = Gy(:, :, i);
    sensitivity(i).Gp = [];
end
end
