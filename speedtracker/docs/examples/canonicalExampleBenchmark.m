function sol = canonicalExampleBenchmark()
%CANONICALEXAMPLEBENCHMARK simple benchmark using the same RHS and settings as the Readme example
    options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
    datahandle = prepareDatahandleForIntegration('benchmark_canonicalExampleRHS', ...
                                                 'solver', 'ode45', ...
                                                 'options', options);
    sol = solveODE(datahandle, [0 20], [1; 0], 5.437);
end