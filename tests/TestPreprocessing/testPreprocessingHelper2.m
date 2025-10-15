function out = testPreprocessingHelper2(in1, in2)
%TESTPREPROCESSINGHELPER2 A simple helper function that contains a switch; used for testing purposes.
%   Supposed to be called from within another helper function.
%   See also TESTPREPROCESSINGHELPER1, TESTPREPROCESSINGRHS
if in1 + in2 <= 10
    out = -in1;
else
    out = -in2;
end
end

