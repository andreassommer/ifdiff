classdef StringUtil
    %STRINGUTILS various string-related functions.

    methods (Static)
        % Return 1 if a value is either a 1x1 string array or a 1xN char array. Useful for checking arguments' formats.
        function isit = isSimpleString(str)
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

        % Make a recognizable string representation of most scalar and vector values.
        % For matrix arrays, this produces a row-major concatenation of the rows, so that isn't so useful. But
        % this is mostly for reporting bad arguments to speedtracker, and those are usually typed out by hand, so it's
        % unlikely someone will accidentally put in a matrix where a vector of strings was expected.
        function str = toStr(x)
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
    end
end