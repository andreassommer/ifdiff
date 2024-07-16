function out = special_function_calls_helper(in1, in2)
%SPECIAL_FUNCTION_CALLS_HELPER A simple helper function that contains a switch; used for testing purposes.
%   See also SPECIAL_FUNCTION_CALLS_RHS.
    if in1 <= in2
        out = in1 + in2;
    else
        out = in1 - in2;
    end
end

