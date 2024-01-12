classdef BenchmarkRunner
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        
    end

    methods
        function results = runBenchmarks(~)
            [status, cmdout] = SystemUtil.safeSystem("git rev-parse --verify HEAD");
            if status ~= 0
                throw(MException("benchmarks:error", "Error getting current commit SHA"));
            end
            results = "commit SHA of snapshot: " + cmdout;
        end
    end
end