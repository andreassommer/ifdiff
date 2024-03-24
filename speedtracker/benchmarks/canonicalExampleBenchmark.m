function benchmark = canonicalExampleBenchmark()
%CANONICALEXAMPLEBENCHMARK Benchmark using the same RHS and settings as the Readme example
    benchmark = struct( ...
        'rhs', 'benchmark_canonicalExampleRHS', ...
        'solver', 'ode45', ...
        'tSpan', [0 20], ...
        'x0', [1; 0], ...
        'p', 5.437, ...
        'options', odeset('AbsTol', 1e-8, 'RelTol', 1e-6) ...
    );
end