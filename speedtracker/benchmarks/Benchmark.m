classdef Benchmark
    %BENCHMARK A benchmark for identifying regressions
    % Consists of:
    % an RHS (as the name of the .m file containing the function)
    % an ODE solver
    % a time horizon
    % initial values, in a column vector matching the dimensions of the RHS
    % a parameter, matching the dimensions that the RHS expects
    % ODE solver options (from odeset)

    properties (GetAccess=public, SetAccess=private)
        id;
        rhs;
        solver;
        tSpan;
        initVals;
        p;
        odeOptions;
    end

    methods (Access=public)
        function this = Benchmark(id, rhs, solver, tSpan, x0, p, odeOptions)
            assert(isa(id, "string"),                            "Benchmark member id is string");
            assert(isa(rhs, "string") || isa(rhs, "char"),       "Benchmark member rhs is string/char");
            assert(isa(solver, "string") || isa(solver, "char"), "Benchmark member solver is a string/char");
            assert(isa(tSpan, "double") && length(tSpan) == 2,   "Benchmark member tSpan is 2x1/1x2 double");
            assert(isa(x0, "double"),                            "Benchmark member initVals is double");
            assert(isa(p, "double"),                             "Benchmark member p is double");
            assert(isa(odeOptions, "struct"),                    "Benchmark member odeOptions is struct");
            this.id = id;
            this.rhs = string(rhs);
            this.solver = string(solver);
            this.tSpan = tSpan;
            this.initVals = x0;
            this.p = p;
            this.odeOptions = odeOptions;
        end
    end
end