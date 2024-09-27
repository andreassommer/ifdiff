function p = plotSolWithJumps(tspan, sol, component, label, color, varargin)
%PLOTSOLWITHJUMPS Given a sol object, plot its trajectory with dots for the discontinuities at the switching points
% see plotPointsWithJumps for more info on the parameters.

% tspan: time span to plot the solution in
% sol: IFDIFF-augmented sol object
% component: which component of the solution to plot. For now, you have to call this function once for each.
% label: legend label
% color: line color. Does not update as of now, you will have to set all your colors by hand.
% options: A struct with parameters specific to plotWithJumps. Keys it can contain:
%   numPoints: How many points to plot. May not be followed exactly, but there should only be a few points too many or
%     too few. Default 1000.
%   minJumpDistance: how far ts- and ts have to be apart (relatively) to plot a jump. Otherwise, the two line
%     segments before and after ts are plotted as a continuous line.
% KeyN, ValueN: additional that are passed on to the plot command for the line, like LineWidth.
% return the plot returned by the last line segment
    if nargin >= 6
        options = varargin{1};
    else
        options = struct();
    end
    if isfield(options, 'numPoints')
        numPoints = options.numPoints;
    else
        numPoints = 1000;
    end

    % Make a set of time points for every interval [t1, t2), with its last entry at a point just to the left of t2
    jumps = sol.switches(find(sol.jumps));
    T = jumpLinspace(tspan(1), tspan(2), jumps, numPoints);
    X = deval(sol, T, component);
    p = plotPointsWithJumps(T, X, jumps, label, color, varargin{:});
end

