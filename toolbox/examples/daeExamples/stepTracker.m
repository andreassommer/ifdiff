function status = stepTracker(t, y, flag)
    persistent acceptedT

    if strcmp(flag,'init')
        acceptedT = [];
    elseif isempty(flag)
        acceptedT(end+1,1) = t;
    elseif strcmp(flag,'done')
        assignin('base','AcceptedSteps',acceptedT);
    end
    
    status = 0;
end

