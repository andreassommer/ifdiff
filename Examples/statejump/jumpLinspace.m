function T = jumpLinspace(t0, tF, jumps, numPoints)
%JUMPLINSPACE Get a mostly-evenly-spaced grid of points, with points just before and just after discontinuities
% t0, tF: interval in which to create the points
% jumps: at every point ts in this array, create a point exactly at ts and one at (ts - eps(ts - eps(ts)), i.e. the
%     closest point before it.
% numPoints: how many points to generate. Will not be exactly followed, as each subinterval [t1, t2] gets
%     ceil(numPoints * (t2-t1)/(tF-t0)) points.
    jumpsExtended = [t0 jumps tF];
    timeGroups = cell(1, length(jumpsExtended) - 1);
    for i = 1:length(jumpsExtended)-1
        t1 = jumpsExtended(i);
        t2 = jumpsExtended(i+1);
        t2Minus = t2 - eps(t2 - eps(t2));
        numPointsI = ceil(numPoints * (t2 - t1)/(tF - t0));
        timeGroups{i} = linspace(t1, t2Minus, numPointsI);
    end
    T = [timeGroups{:}];
end

