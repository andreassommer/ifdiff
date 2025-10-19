function y = leftLimit(x)
%LEFTLIMIT get a number that is slightly smaller than x, used for approximating the left limit of a function at x.

% This implementation actually gets the next-smallest number that can be represented in the floating-point grid.
% eps is the difference to the next-larger number. in most cases, this is also the difference to the next-smallest.
% only for powers of two do we need to use eps(t2-eps(t2)). Also appears to work for 0 and denormal numbers
    y = x - eps(x - eps(x));
end