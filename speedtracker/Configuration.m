classdef Configuration
    %CONFIGURATION Configuration options for manual editing by users
    % Edit them to set defaults, some can be overridden when calling certain commands.

    properties (Constant)
        % What format to output benchmarking results in.
        % Can be one of:
        %   'OneTable' (all results in a single table, default)
        %   'NTables' (one table for each benchmark)
        %   'Raw' (directly return the internal result objects that the BenchmarkRunner returns)
        OutputType = 'OneTable';
        % Tolerance for deciding whether the xEnd values of two different snapshots' benchmarking runs are equal.
        XEndTol = 1e-6;
    end
end
