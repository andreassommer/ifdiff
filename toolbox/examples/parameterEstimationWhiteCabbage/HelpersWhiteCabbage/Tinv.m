function inv = Tinv (x, n)

  if (nargin ~= 2)
    error("tinv: Incorrect usage: inv = tinv(x, n)");
  end

  if (~isreal (x) || ~isreal (n))
    error ("tinv: X and N must not be complex");
  end

  if (isa (x, "single") || isa (n, "single"))
    inv = NaN (size (x), "single");
  else
    inv = NaN (size (x));
  end

  k = (x == 0) & (n > 0);
  inv(k) = -Inf;

  k = (x == 1) & (n > 0);
  inv(k) = Inf;

  if (isscalar (n))
    k = (x > 0) & (x < 1);
    if ((n > 0) && (n < 10000))
      inv(k) = (sign (x(k) - 1/2) ...
                .* sqrt (n * (1 ./ BetaInv (2*min (x(k), 1 - x(k)), ...
                                            n/2, 1/2) - 1)));
    elseif (n >= 10000)
      %% For large n, use the quantiles of the standard normal
      inv(k) = sqrt (2) * erfinv (2 * x(k) - 1);
    end
  else
    k = (x > 0) & (x < 1) & (n > 0) & (n < 10000);
    inv(k) = (sign (x(k) - 1/2) ...
              .* sqrt (n(k) .* (1 ./ BetaInv (2*min (x(k), 1 - x(k)), ...
                                              n(k)/2, 1/2) - 1)));

    %% For large n, use the quantiles of the standard normal
    k = (x > 0) & (x < 1) & (n >= 10000);
    inv(k) = sqrt (2) * erfinv (2 * x(k) - 1);
  end

end