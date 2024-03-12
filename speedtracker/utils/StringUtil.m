classdef StringUtil
    %STRINGUTILS various string-related functions.

    methods (Static)
        function isit = isSimpleString(str)
            % Return 1 if a value is either a 1x1 string array or a 1xN char array. Useful for checking arguments' formats.
            isit = 0;
            if isstring(str)
                if (length(size(str)) == 2 && all(size(str) == [1 1]))
                    isit = 1;
                end
            elseif ischar(str)
                if (length(size(str)) == 2 && (size(str, 1) == 1))
                    isit =1;
                end
            end
        end

        function isit = isStringArray(str)
            % Return 1 if a value is a string array (vector of strings) or a vector cellstring (cell array of char vectors)
            isit = 0;
            if isstring(str) && numel(str) == length(str)
                isit = 1;
            elseif iscellstr(str) && numel(str) == length(str)
                isit = 1;
            end
        end

        function msg = describeBadStringArray(value)
            % Return a message describing why a value did not pass the test of StringUtil.isStringArray()
            % Will return nonsense if the value DOES pass StringUtil.isStringArray().
            if isstring(value)
                msg = sprintf("expecting vector of strings, but array has dimensions %s", StringUtil.dimStr(value));
            elseif iscellstr(value)
                msg = sprintf("expecting vector of strings, but array has dimensions %s", StringUtil.dimStr(value));
            elseif iscell(value)
                msg = "expecting cellstring, but cell elements are not (all) of type char";
            else
                msg = sprintf("expecting string array or cellstring, but value has type %s", class(value));
            end
        end

        function str = toStr(x)
            % Make a recognizable string representation of most scalar and vector values.
            % For matrix arrays, this produces a row-major concatenation of the rows, so that isn't so useful. But
            % this is mostly for reporting bad arguments to speedtracker, and those are usually typed out by hand, so it's
            % unlikely someone will accidentally put in a matrix where a vector of strings was expected.
            if (isempty(x))
                str = "[]";
            else
                joined = strjoin(string(x), ", ");
                if size(x) == 1
                    str = joined;
                else
                    str = "[" + joined + "]";
                end
            end
        end

        function str = dimStr(array)
            % Return a string representation of an array's dimensions
            str = strjoin(string(size(array)), " x ");
        end
    end
end