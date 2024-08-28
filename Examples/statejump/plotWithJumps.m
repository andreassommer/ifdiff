function p = plotWithJumps(T, X, jumps, label, color, varargin)
%PLOTWITHJUMPS Plot a line that has discontinuities using circles and dots to show the discontinuities nicely.
% plotWithJumps(T, X)
% plotWithJumps(T, X, label, color, options)
% plotWithJumps(T, X, label, color, options, Key1, Value1, ..., KeyN, ValueN)
% p = plotWithJumps(_)
%
% For every two points in jumps, plot the points in T that are between them (left-exclusive, right-inclusive). Then,
% plot a filled circle at the first point and an empty circle at the last point (cadlag). Note that plotWithJumps
% does not add extra points; there may be a visible gap if you did not space them tightly enough.
% For every point ts in jumps, the last time point before it is called ts-
% 
% X may only have one component.
% label: legend label
% color: line color.
% options: A struct with parameters specific to plotWithJumps. Keys it can contain:
%   minJumpDistance: how far ts- and ts have to be apart (relatively) to plot a jump. Otherwise, the two line
%     segments before and after ts are plotted as a continuous line.
% KeyN, ValueN: additional that are passed on to the plot command for the line, like color and thickness.
% return the plot returned by the last line segment

    if nargin >= 1
        options = varargin{1};
    else
        options = struct();
    end
    if isfield(options, 'minJumpDistance')
        minJumpDistance = options.minJumpDistance;
    else
        minJumpDistance = 1e-6;
    end

    lgd = legend();
    holdState = ishold;
    hold on;
    lgd.AutoUpdate = 'off';
    % TODO code
    lgd.AutoUpdate = 'on';
    hold(holdState);
end