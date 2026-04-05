function [funcSolPiecewise, tSwitch, switchingFunc, varargout] = canonicalExampleAnalyticSolution()
%[funcSolPiecewise, tSwitch, switchingFunc, varargout] = CANONICALEXAMPLEANALYTICSOLUTION()
%[funcSolPiecewise, tSwitch, switchingFunc, t0, y0, p] = CANONICALEXAMPLEANALYTICSOLUTION()
%
%Return the analytic solution including switching times and functions for the canonical example.
%
%OUTPUT:
%   funcSolPiecewise - Function that takes time points t (1xn double)
%   and outputs solution y (2xn double) at the given points
%       function_handle
%
%   tSwitch - Switching times
%       1x2 double
%
%   switchingFunc - Switching functions
%       1x2 cell of function_handle
%
%   t0, y0, p (optional) - Initial conditions and parameters (currently hardcoded)
%       double, 2x1 double, double

% ============Derivation===============
% RHS:
% f_1(t,y,p) = 0.01*t^2 + y_2^3
% f_2(t,y,p) = 0 if y_1 < p
%            = 5 if p <= y_1 < p + 0.5
%            = 0 if y_1 >= p + 0.5
% =====================================
% Submodel 1:
% Assuming initial conditions y(0) = [1; 0] and p > 1, i.e. y_2 = 0 and y_1 < p
% f^1_1(t,y,p) = 0.01*t^2
% f^1_2(t,y,p) = 0
%
% Solution given by:
% y^1_1(t) = (1/3)*0.01*t^3 + 1
% y^1_2(t) = 0
%
% First switch t_1 when y^1_1(t_1) = p
% t_1 = root3[((1/3)*0.01)^(-1) * (p-1)]
% =====================================
% Submodel 2:
% RHS is now:
% f^2_1(t,y,p) = 0.01*t^2 + y_2(t)^3
% f^2_2(t,y,p) = 5
%
% Solution:
% y^2_2(t) = 5*(t-t_1)
% Plug into RHS: f^2_1(t,y,p) = 0.01*t^2 + 125*(t-t_1)^3
% Integrate:
% int(0.01*t^2) = (1/3)*0.01+t^3 + C = y_1^1(t) - 1 + C
% int(125*(t-t_1)^3) = 125/4*(t-t_1)^4 + C
% y^2_1(t) = 125/4*(t-t_1)^4 + y^1_1(t) - 1 + C
% Since y^2_1(t_1) = y^1_1(t_1) it follows C = 1, i.e.
% y^2_1(t) = 125/4*(t-t_1)^4 + y^1_1(t)
%
% Second switch t_2 when y^2_1(t_2) = p + 0.5
% Determining t_2 involves solving a quartic.
% In practice numerical solution should be used (well-suited here since y^2_1(t) is increasing for t>=t_1>=0)
% =====================================
% Submodel 3:
% RHS is now:
% f^3_1(t,y,p) = 0.01*t^2 + y_2(t)^3 = 0.01*t^2 + y^2_2(t_2)^3
% f^3_2(t,y,p) = 0
%
% Solution given by:
% y^3_1(t) = (1/3)*0.01*t^3 + y^2_2(t_2)^3*t + C = y^1_1(t) + y^2_2(t_2)^3*t - 1 + C
% y^3_2(t) = y^2_2(t_2)
%
% Determine integration constant via condition y^3_1(t_2) = y^2_1(t_2):
% y^2_1(t_2) = y^1_1(t_2) + 125/4*(t_2-t_1)^4 = y^1_1(t_2) + 1/20*y^2_2(t_2)^4
% y^3_1(t_2) = y^1_1(t_2) + y^2_2(t_2)^3*t_2 - 1 + C
% Simplify and rearrange equation:
% C = 1 + y^2_2(t_2)^3*(1/20*y^2_2(t_2) - t_2)

% TODO: Make it possible to specify initial conditions and parameters.
% For now hardcoded to simplify computations.
t0 = 0;
y0 = [1; 0];
p = 5.437;
if nargout > 3
    varargout{1} = t0;
end
if nargout > 4
    varargout{2} = y0;
end
if nargout > 5
    varargout{3} = p;
end


% RHS:
% f_1(t,y,p) = tFac*t^tExp + y_2^yExp
% f_2(t,y,p) = 0 if y_1 < p
%            = dy2 if p <= y_1 < p + pDelta
%            = 0 if y_1 >= p + pDelta
pDelta = 0.5;
tFac = 0.01;
tExp = 2;
yExp = 3;
dy2 = 5;

y = cell(2,3);
tSwitch = zeros(1,2);
switchingFunc = cell(size(tSwitch));
% Submodel 1
y{1,1} = @(t) y0(1) + (tFac/(tExp+1)) .* t.^(tExp+1);
y{2,1} = @(t) y0(2) + zeros(size(t));
switchingFunc{1} = @(t) p - y{1,1}(t);
tSwitch(1) = nthroot((tExp+1)/tFac * (p-y0(1)), tExp+1);
% Submodel 2
y{1,2} = @(t) y{1,1}(t) + (dy2^3/(yExp+1)) .* (t-tSwitch(1)).^(yExp+1);
y{2,2} = @(t) dy2 .* (t-tSwitch(1));
switchingFunc{2} = @(t) (p+pDelta) - y{1,2}(t);
tSwitch(2) = fzero(switchingFunc{2}, tSwitch(1));
y22Switch = y{2,2}(tSwitch(2));
% Submodel 3
IC = (y22Switch^yExp) * (y22Switch/(dy2*(yExp+1)) - tSwitch(2));
y{1,3} = @(t) IC + y{1,1}(t) + y22Switch^yExp.*t;
y{2,3} = @(t) y22Switch + zeros(size(t));

% Return full column vectors for each submodel.
yFull = cell(1,3);
for idxModel=1:size(y, 2)
    yFull{idxModel} = @(t) [y{1, idxModel}(t); y{2, idxModel}(t)];
end

funcSolPiecewise = @(t) evalPiecewise(t, yFull, length(y0), tSwitch);
end

function y = evalPiecewise(t, solPiece, dimy, sw)
% Make sure eval points and switching times are sorted in ascending order.
[t, tSortIdx] = sort(t);
sw = sort(sw);
y = zeros(dimy, length(t));

done = false;
idxModelStart = 1;
for idxSw=1:length(sw)
    % Since eval points and switching times are sorted, we look for the first eval point that lies after the next switch.
    idxModelEnd = (idxModelStart - 1) + find(t(idxModelStart:end) >= sw(idxSw), 1);
    % If no such point exists, then we stay in the same model until the end.
    if isempty(idxModelEnd)
        y(:, idxModelStart:end) = solPiece{idxSw}(t(idxModelStart:end));
        done = true;
        break
    end
    % Otherwise, evaluate points before switch in the current model and update model for next iteration.
    y(:, idxModelStart:idxModelEnd-1) = solPiece{idxSw}(t(idxModelStart:idxModelEnd-1));
    idxModelStart = idxModelEnd;
end

% If we actually reach the last model or stay in first model, then we have to evaluate the remaining points in that model.
if ~done
    y(:, idxModelStart:end) = solPiece{end}(t(idxModelStart:end));
end

% Reverse the sorting
y(:, tSortIdx) = y(:, 1:end);
end
