function p = plotPointsWithJumps(T, X, jumps, label, color, varargin)
%PLOTPOINTSWITHJUMPS Plot a line that has discontinuities using circles and dots to show the discontinuities nicely.
% plotPointsWithJumps(T, X, jumps, label, color)
% plotPointsWithJumps(T, X, jumps, label, color, options)
% plotPointsWithJumps(T, X, jumps, label, color, options, Key1, Value1, ..., KeyN, ValueN)
% p = plotPointsWithJumps(_)
%
% Sort the T and X into groups separated by the jumps. For each group, draw its T and X as a line, with an empty
% dot at the right end and a filled one at the left (except the start and end point of the entire data set)
%
% T: independent variable (time) points. Must be unique and ascendingly sorted.
% X: dependent variable (function) points. May only have one component as of now.
% jumps: points to treat as discontinuities. If the X-point directly before and after a jump are too close together
%        (see options.minJumpDistance parameter below), the jump is ignored and the segments before and after plotted
%        contiguously.
% label: legend label
% color: line color. Does not update as of now, you will have to set all your colors by hand.
% options: A struct with parameters specific to plotWithJumps. Keys it can contain:
%   minJumpDistance: how far ts- and ts have to be apart (relatively) to plot a jump. Otherwise, the two line
%     segments before and after ts are plotted as a continuous line.
% KeyN, ValueN: additional that are passed on to the plot command for the line, like LineWidth.
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
    if nargin >= 7
        plotOptions = varargin(2:end);
    else
        plotOptions = {};
    end

    if isempty(T)
        return
    end

    if isempty(jumps)
        timeGroups = {T};
    else
        % 1. Create groups of time points on the jumps, merging those groups whose start and end points are
        % closer together than minJumpDistance
        timeGroups = {};
        valueGroups = {};
        numTimeGroups = 0;
        % We iterate over the jump points, using jumpIndex to get the next one each time
        jumpsExtended = [jumps T(end)+eps(T(end))];
        jumpIndex = 1;
        % index of the last time point that was added to a time group
        lastTimeIndex = 0;
        while lastTimeIndex < length(T)
            nextTimeIndex = max(find(T < jumpsExtended(jumpIndex)));
            if nextTimeIndex == length(T)
                numTimeGroups = numTimeGroups + 1;
                timeGroups{numTimeGroups} = T(lastTimeIndex+1:nextTimeIndex);
                valueGroups{numTimeGroups} = X(lastTimeIndex+1:nextTimeIndex);
                lastTimeIndex = nextTimeIndex;
            else
                endX       = X(nextTimeIndex);
                nextStartX = X(nextTimeIndex + 1);
                if abs(endX - nextStartX) / max(abs([endX, nextStartX])) > minJumpDistance
                    numTimeGroups = numTimeGroups + 1;
                    timeGroups{numTimeGroups} = T(lastTimeIndex+1:nextTimeIndex);
                    valueGroups{numTimeGroups} = X(lastTimeIndex+1:nextTimeIndex);
                    lastTimeIndex = nextTimeIndex;
                end
            end
            jumpIndex = jumpIndex + 1;
        end
    end
    lgd = legend();
    holdState = ishold;
    hold on;
    lgd.AutoUpdate = 'off';
    % plot all line segments except the last one, we will return it
    for i=1:length(timeGroups) - 1
        plot(timeGroups{i}, valueGroups{i}, 'Color', color, plotOptions{:});
    end
    % plot the dots at the starts and ends of the segments
    jumpsLeft  = cellfun(@(ts) ts(end), timeGroups(1:end-1));
    xLeft      = cellfun(@(xs) xs(end), valueGroups(1:end-1));
    jumpsRight = cellfun(@(ts) ts(1), timeGroups(2:end));
    xRight     = cellfun(@(xs) xs(1), valueGroups(2:end));
    plot(jumpsLeft, xLeft, 'o', 'Color', color, 'MarkerSize', CIRCLE_MARKER_SIZE);
    plot(jumpsLeft, xLeft, '.w', 'MarkerSize', DOT_MARKER_SIZE);
    plot(jumpsRight, xRight, '.', 'Color', color, 'MarkerSize', DOT_MARKER_SIZE);

    %plot the last line segment
    lgd.AutoUpdate = 'on';
    p = plot(timeGroups{end}, valueGroups{end}, 'Color', color, 'DisplayName', label, plotOptions{:});
    if holdState
        hold on
    else
        hold off;
    end
end