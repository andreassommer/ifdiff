classdef KeyFunctionMap
    %this = KEYFUNCTIONMAP(keyFunction)
    %
    %Hash map that can use arbitrary data types as keys by being provided with a char array conversion function.
    %
    %Note: Used as a replacement for dictionary introduced in R2022b. IFDIFF should remain compatible with R2016a.
    %
    %INPUT:
    %   keyFunction - Function that takes a key value and converts it to a char array.
    %       function handle

    properties (Access=private)
        map = [];
        keyFunction = [];
    end

    properties (Dependent)
        size
    end

    methods
        % Constructor
        function this = KeyFunctionMap(keyFunction)
            this.map = containers.Map('KeyType', 'char', 'ValueType', 'any');

            if nargin == 0
                return
            end

            this.keyFunction = keyFunction;
        end

        function val = get(this, key)
            %val = this.GET(key)
            %
            %Retrieve a value from the hash map using a key.
            %
            %INPUT:
            %   key - Key of the value to be retrieved.
            %   Note that the key can be of any data type accepted by the key function.
            %       any
            %
            %OUTPUT:
            %   val - Value corresponding to the key if it exists or empty array otherwise.
            %       any | empty array

            key = this.keyFunction(key);

            if this.map.isKey(key)
                val = this.map(key);
            else
                val = [];
            end
        end

        function set(this, key, val)
            %this.SET(key, val)
            %
            %Insert a key-value pair into the hash map.
            %
            %Note: Map is a handle class, and can therefore be modified directly in this function.
            %In particular, this function doesn't need an output, even though KeyFunctionMap itself is a value class.
            %
            %INPUT:
            %   key - Key belonging to the value that should be inserted into the map.
            %   Note that the key can be of any data type accepted by the key function.
            %       any
            %
            %   val - Value to be inserted into the map.
            %       any
            %
            %OUTPUT:
            %   this.map - Updated map with the key-value pair inserted.

            key = this.keyFunction(key);
            this.map(key) = val;
        end

        function size = get.size(this)
            size = this.map.Count;
        end
    end
end
