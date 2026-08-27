function pdf = BetaPdf (x, a, b)
% BETAPDF  PDF of the Beta distribution
%  PDF = betapdf(X, A, B) computes, for each element of X, the PDF
%  at X of the beta distribution with parameters A and B (i.e.
%  mean of the distribution is A/(A+B) and variance is
%  A*B/(A+B)^2/(A+B+1) ).

if (nargin ~= 3)
    error ('betapdf: you must give three arguments');
end

if (~isscalar (a) || ~isscalar(b))
    [retval, x, a, b] = common_size (x, a, b);
    if (retval > 0)
        error ('betapdf: x, a and b must be of common size or scalar');
    end
end

sz = size (x);
pdf = zeros (sz);

k = find (~(a > 0) | ~(b > 0) | isnan (x));
if (any (k))
    pdf (k) = NaN;
end

k = find ((x > 0) & (x < 1) & (a > 0) & (b > 0));
if (any (k))
    if (isscalar(a) && isscalar(b))
        pdf(k) = exp ((a - 1) .* log (x(k)) ...
                      + (b - 1) .* log (1 - x(k))-gammaln(a)-gammaln(b)+gammaln(a+b));
    else
        pdf(k) = exp ((a(k) - 1) .* log (x(k)) ...
                      + (b(k) - 1) .* log (1 - x(k))-gammaln(a(k))-gammaln(b(k))+gammaln(a(k)+b(k)));
    end
end

end