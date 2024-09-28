function sol = statejumpBenchmark()
%STATEJUMPBENCHMARK Benchmark for state jumps
    options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
    datahandle = prepareDatahandleForIntegration('twoJumpsGoodRHS', ...
                                                 'solver', 'ode45', ...
                                                 'options', options);
    sol = solveODE(datahandle, [0 20.1], 1, 0);
end

