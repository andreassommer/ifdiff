function p = plotWithJumps(tspan, f, jumps, label, color, varargin)
%PLOTWITHJUMPS Plot a line that has discontinuities using circles and dots to show the discontinuities nicely.
% plotWithJumps(T, X)
% plotWithJumps(T, X, label, color, options)
% plotWithJumps(T, X, label, color, options, Key1, Value1, ..., KeyN, ValueN)
% p = plotWithJumps(_)
%
% For every two points in jumps, draw a line from t1 to t2 (left-exclusive, right-inclusive)
% 
% label: legend label
% color: line color. Does not update as of now, you will have to set all your colors by hand.
% options: A struct with parameters specific to plotWithJumps. Keys it can contain:
%   minJumpDistance: how far ts- and ts have to be apart (relatively) to plot a jump. Otherwise, the two line
%     segments before and after ts are plotted as a continuous line.
%   pointsPerSegment: how many time points to plot per line segment
% KeyN, ValueN: additional that are passed on to the plot command for the line, like color and thickness.
% return the plot returned by the last line segment

    CIRCLE_MARKER_SIZE = 8;
    DOT_MARKER_SIZE    = 24;

    if nargin >= 6
        options = varargin{1};
    else
        options = struct();
    end
    if isfield(options, 'minJumpDistance')
        minJumpDistance = options.minJumpDistance;
    else
        minJumpDistance = 1e-6;
    end
    if isfield(options, 'pointsPerSegment')
        pointsPerSegment = options.pointsPerSegment;
    else
        pointsPerSegment = 100;
    end
    plotOptions = varargin(2:end);

    if tspan(1) == tspan(2)
        return
    end

    % 1. Create groups of time points on the jumps, merging those groups whose start and end points are
    % closer together than minJumpDistance
    if isempty(jumps)
        timeGroups = {linspace(tspan(1), tspan(2), pointsPerSegment)};
    else
        nontrivialJumps = [];
        for i=1:length(jumps)
            ti      = jumps(i);
            tiMinus = ti - eps(ti - eps(ti));
            xi = f(ti);
            xiMinus = f(tiMinus);
            if abs(xiMinus - xi) / max(abs([xiMinus xi])) > minJumpDistance
                nontrivialJumps = [nontrivialJumps ti];
            end
        end
        segmentBoundaries = [tspan(1) nontrivialJumps tspan(2)];
        timeGroups = cell(1, length(segmentBoundaries) - 1);
        for j=1:length(segmentBoundaries) - 1
            t1 = segmentBoundaries(j);
            t2 = segmentBoundaries(j+1);
            timeGroups{j} = linspace(t1, t2-eps(t2 - eps(t2)), pointsPerSegment);
        end
    end
    lgd = legend();
    holdState = ishold;
    hold on;
    lgd.AutoUpdate = 'off';
    % plot all line segments except the last one, we will return it
    for i=1:length(timeGroups) - 1
        plot(timeGroups{i}, f(timeGroups{i}), 'Color', color, plotOptions{:});
    end
    % plot the dots at the starts and ends of the segments
    jumpsLeft  = cellfun(@(ts) ts(end), timeGroups(1:end-1));
    xLeft      = f(jumpsLeft);
    jumpsRight = cellfun(@(ts) ts(1), timeGroups(2:end));
    xRight     = f(jumpsRight);
    plot(jumpsLeft, xLeft, 'o', 'Color', color, 'MarkerSize', CIRCLE_MARKER_SIZE);
    plot(jumpsLeft, xLeft, '.w', 'MarkerSize', DOT_MARKER_SIZE);
    plot(jumpsRight, xRight, '.', 'Color', color, 'MarkerSize', DOT_MARKER_SIZE);

    %plot the last line segment
    lgd.AutoUpdate = 'on';
    p = plot(timeGroups{end}, f(timeGroups{end}), 'Color', color, 'DisplayName', label, plotOptions{:});
    if holdState
        hold on
    else
        hold off;
    end
end