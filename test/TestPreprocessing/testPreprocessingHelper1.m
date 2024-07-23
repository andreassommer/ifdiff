function out = testPreprocessingHelper1(in1, in2)
%TESTPREPROCESSINGHELPER1 A simple helper function that contains a switch; used for testing purposes.
%   See also TESTPREPROCESSINGRHS.
x = testPreprocessingHelper2(in1, in2);
if in1 <= in2
    out = x;
else
    out = -x;
end
end

