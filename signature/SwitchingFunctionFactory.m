classdef SwitchingFunctionFactory < handle
    %SWITCHINGFUNCTIONFACTORY Summary of this class goes here
    properties (Access=public)
        mtreeArray = {}
        functionNameArray = {}
        writePath = ''
    end

    methods
        function obj = SwitchingFunctionFactory(mtreeArray, functionNameArray, writePath)
            if nargin == 0
                return
            end

            obj.mtreeArray = mtreeArray;
            obj.functionNameArray = functionNameArray;
            obj.writePath = writePath;
        end

        
    end
end

