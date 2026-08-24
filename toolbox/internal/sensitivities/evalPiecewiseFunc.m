function y = evalPiecewiseFunc(x, piecewiseFunc, dimOut, intervalBoundaries)
%evalPiecewiseFunc - Evaluate a function defined piecewise over half-closed intervals [a,b)
%
%    Syntax
%      y = evalPiecewiseFunc(x, piecewiseFunc, dimOut, intervalBoundaries)
%
%    Input Arguments
%      x - Evaluation points
%        m-element numeric vector
%      piecewiseFunc - Interval subfunctions
%        k-element cell array of function handles which take an m-element numeric vector of evaluation points
%        and return an n-by-m numeric matrix where the i-th column corresponds to the function value
%        for the i-th evaluation point.
%      dimOut - Length of the vector-valued function output
%        integer scalar
%      intervalBoundaries - Points defining the subfunction interval boundaries
%        (k-1)-element numeric vector where the i-th entry corresponds to the (excluded) interval end point
%        of the i-th subfunction and the (included) interval start point of the (i+1)-th subfunction.
%
%    Output Arguments
%      y - Function values for the given points
%        n-by-m numeric matrix, where n is the function output dimension and m is the number of time points

y = zeros(dimOut, length(x));
if isempty(x)
    return
end

% Make sure evaluation points and interval boundaries are strictly increasing.
[x, ~, sortIdx] = unique(x);
intervalBoundaries = unique(intervalBoundaries);

idxStart = 1;
while idxStart <= length(x)
    % Determine interval which contains next evaluation point.
    idxFunc = find(x(idxStart) < intervalBoundaries, 1);
    if isempty(idxFunc)
        func = piecewiseFunc{end};
        idxEnd = length(x);
    else
        func = piecewiseFunc{idxFunc};
        endPoint = intervalBoundaries(idxFunc);
        % Determine last evaluation point which lies inside the interval.
        idxEnd = idxStart + (find(x(idxStart:end) < endPoint, 1) - 1);
    end

    y(:, idxStart:idxEnd) = func(x(idxStart:idxEnd));
    idxStart = idxEnd+1;
end

% Reverse the sorting.
y(:, 1:end) = y(:, sortIdx);
end
