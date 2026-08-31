function cdf = BetaCdf (x, a, b)
% BETACDF  CDF of the Beta distribution
%  CDF = BetaCdf(X, A, B) computes, for each element of X, the CDF
%  at X of the beta distribution with parameters A and B (i.e.
%  mean of the distribution is A/(A+B) and variance is
%  A*B/(A+B)^2/(A+B+1) ).

if (nargin ~= 3)
    error ('Betacdf: you should provide three arguments');
end

if (~isscalar (a) || ~isscalar(b))
    [retval, x, a, b] = common_size (x, a, b);
    if (retval > 0)
        error ('Betacdf: x, a and b must be of common size or scalar');
    end
end

sz = size(x);
cdf = zeros (sz);

k = find (~(a > 0) | ~(b > 0) | isnan (x));
if (any (k))
    cdf (k) = NaN;
end

k = find ((x >= 1) & (a > 0) & (b > 0));
if (any (k))
    cdf (k) = 1;
end

k = find ((x > 0) & (x < 1) & (a > 0) & (b > 0));
if (any (k))
    if (isscalar (a) && isscalar(b))
        cdf (k) = betainc (x(k), a, b);
    else
        cdf (k) = betainc (x(k), a(k), b(k));
    end
end

end
