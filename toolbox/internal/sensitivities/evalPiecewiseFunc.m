function y = evalPiecewiseFunc(t, piecewiseFunc, dimy, switches)
% Make sure eval points and switching times are sorted in ascending order.
[t, ~, tUndoSortIdx] = unique(t);
switches = unique(switches);
y = zeros(dimy, length(t));

done = false;
idxModelStart = 1;
for idxSw=1:length(switches)
    % Since eval points and switching times are sorted, we look for the first eval point that lies after the next switch.
    idxModelEnd = (idxModelStart - 1) + find(t(idxModelStart:end) >= switches(idxSw), 1);
    % If no such point exists, then we stay in the same model until the end.
    if isempty(idxModelEnd)
        y(:, idxModelStart:end) = piecewiseFunc{idxSw}(t(idxModelStart:end));
        done = true;
        break
    end
    % Otherwise, evaluate points before switch in the current model and update model for next iteration.
    y(:, idxModelStart:idxModelEnd-1) = piecewiseFunc{idxSw}(t(idxModelStart:idxModelEnd-1));
    idxModelStart = idxModelEnd;
end

% If we actually reach the last model or stay in first model, then we have to evaluate the remaining points in that model.
if ~done
    y(:, idxModelStart:end) = piecewiseFunc{end}(t(idxModelStart:end));
end

% Reverse the sorting
y(:, tUndoSortIdx) = y(:, 1:end);
end
