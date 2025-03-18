classdef HashMap < handle
    %CACHE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=private)
        map = [];
        hash = [];
    end

    properties (Dependent)
        size
    end
    
    methods
        function obj = HashMap(hash)
            obj.map = containers.Map('KeyType', 'char', 'ValueType', 'any');
            if nargin > 0
                obj.hash = hash;
            end
        end
        
        function val = get(obj, key)
            key = obj.hash(key);
            if obj.map.isKey(key)
                val = obj.map(key);
            else
                val = [];
            end
        end

        function set(obj, key, val)
            key = obj.hash(key);
            obj.map(key) = val;
        end

        function size = get.size(obj)
            size = obj.map.Count;
        end
    end
end
