function benchmark = expBenchmark()
%EXPBENCHMARK a simple benchmark using an exponential function that switches from decay to growth
    benchmark = struct( ...
        "rhs", "expRHS", ...
        "solver", "ode45", ...
        "tSpan", [0 4], ...
        "x0", exp(2), ...
        "p", 1, ...
        "options", odeset('AbsTol', 1e-8, 'RelTol', 1e-6) ...
    );
end