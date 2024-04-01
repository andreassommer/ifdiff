function sol = expBenchmark()
%EXPBENCHMARK a simple benchmark using an exponential function that switches from decay to growth
    options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
    datahandle = prepareDatahandleForIntegration('benchmark_expRHS', ...
                                                 'solver', 'ode45', ...
                                                 'options', options);
    sol = solveODE(datahandle, [0 4], exp(2), 1);
end