function df = finiteDifference(f, x, h, v)
fx = f(x);
dimx = length(x);
dimf = length(fx);

fulljac = isempty(v);
if fulljac
    % Full jacobian
    nd = dimx;
    xh = x;
else
    % Directional derivatives
    nd = size(v, 2);
    v = x + v*h;
end
df = zeros(dimf, nd);

for i=1:nd
    % Uniform step or different for each component/direction?
    if isscalar(h)
        hi = h;
    else
        hi = h(i);
    end
    if fulljac
        % No directions given, so assume unit vectors
        xh(i) = x(i) + hi;
    else
        xh = v(:, i);
    end
    % Compute forward finite difference
    df(:, i) = (f(xh) - fx) ./ hi;

    % Restore original vector if only one component was disturbed.
    if fulljac
        xh(i) = x(i);
    end
end
end
