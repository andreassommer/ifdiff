function sol_euler = loadEulerOrComputeLive(fname, vname, rhs, tspan, x0, p, step)
if isfile(fname)
    tmp = load(fname, vname);
    sol_euler = tmp.(vname);
    fprintf('Loading %s from file %s\n', vname, fname);
    return
end
fprintf('Integrating with explicit Euler (might take a while) ...\n')
sol_euler = explEuler(rhs, tspan, x0, p, step);
fprintf('Saving result to %s for later reuse.\n', fname);
save(fname, vname);
end

% Helper

function sol = explEuler(rhs, tspan, x0, p, stepsize)
xdim = length(x0);
stepcount = (tspan(end)-tspan(1)) / stepsize;
sfac = 0.001; % store factor
n_out = ceil(stepcount*sfac) + 1;

Xi = reshape(x0, [], 1);
X = zeros(xdim, n_out);
X(:,1) = Xi;

k = 2; nextout = ceil(1 / sfac);
for i=2:stepcount
    Xi = Xi + stepsize * rhs(i*stepsize, Xi, p);
    if (i == nextout)
        X(:,k) = Xi; k = k + 1;
        nextout = nextout + ceil(1 / sfac);
    end
    if ~mod(i, stepcount / 100), fprintf('.'); end
end
fprintf('\n');
T = linspace(tspan(1), tspan(end), n_out);
sol.x = T;
sol.y = X;
end