function solveODE_prepareNextStage(datahandle)
%SOLVEODE_PREPARENEXTSTAGE Compute the starting state and signature for the next stage after a switching point.
data = datahandle.getData();

t = data.SWP_detection.t2;
xMinus = deval(data.SWP_detection.solution_until_t2, t);

incrementFunction = data.SWP_detection.jumpFunction{end};
if isempty(incrementFunction)
    xPlus = xMinus;
else
    xPlus = applyJumpIncrement(incrementFunction, t, xMinus, data.SWP_detection.parameters);
end

data.SWP_detection.x2 = {xMinus, xPlus};

% Get the new signature at t2, without forced branching
[switch_cond, ctrlif_index, function_index] = ctrlif_getSignature(datahandle, t, xPlus);
signatureNew = BranchingSignature(data.mtreeplus{2, 1}, switch_cond, ctrlif_index, function_index);
data.SWP_detection.signature{end + 1} = signatureNew;

datahandle.setData(data);
end

%% Helpers
function x = applyJumpIncrement(incrementFunction, t, x, p)
try
    increment = incrementFunction([], t, x, p); % first arg empty for datahandle
catch eCause
    throwAsCaller(unableToComputeJumpIncrementError(eCause, incrementFunction, t, x, p));
end

try
    if ~isnumeric(increment)
        throw(invalidIncrementTypeError(increment));
    end
    if ~isequal(size(x), size(increment))
        throw(invalidIncrementDimensionError(x, increment));
    end
    if ~all(isfinite(increment))
        throw(infiniteIncrementError(increment));
    end

    x = x + increment;
catch eCause
    throwAsCaller(unableToPerformJumpUpdateError(eCause, incrementFunction, t, x, p));
end
end

%% Exceptions
function s = solverStatus(incrementFunction, t, x, p)
format = [ ...
    'Solver status when error occured:\n' ...
    '%%%ds = %%s\n' ...
    '%%%ds = %%g\n' ...
    '%%%ds = [%%s]\n' ...
    '%%%ds = [%%s]\n'];

fields = {'Increment Function name', 'Time t', 'State x', 'Parameters p'};
nFields = numel(fields);
largestField = max(cellfun('length', fields));
fieldWidth = repmat({largestField}, 1, nFields);
format = sprintf(format, fieldWidth{:});

vals = {func2str(incrementFunction), t, arrayStrJoin(x, ', ', '%g'), arrayStrJoin(p, ', ', '%g')};

% Reorder elements into field-value pairs for usage with sprintf.
formatVals = cell(1, 2 * nFields);
formatVals(1:2:end) = fields;
formatVals(2:2:end) = vals;

s = sprintf(format, formatVals{:});
end

function e = unableToComputeJumpIncrementError(eCause, incrementFunction, t, x, p)
msg = ['Unable to compute state jump increment.\n', solverStatus(incrementFunction, t, x, p)];
e = MException('IFDIFF:PrepareNextIntegrationStage:UnableToComputeJumpIncrement', msg);
e = e.addCause(eCause);
end

function e = unableToPerformJumpUpdateError(eCause, incrementFunction, t, x, p)
msg = ['Unable to perform state jump update.\n', solverStatus(incrementFunction, t, x, p)];
e = MException('IFDIFF:PrepareNextIntegrationStage:UnableToPerformJumpUpdate', msg);
e = e.addCause(eCause);
end

function e = invalidIncrementDimensionError(x, increment)
msg = [ ...
    'Invalid increment dimension: Increment specified in jump_update function must have ' ...
    'same dimensions as state vector [%s], but has dimensions [%s] instead.\n'];
e = MException( ...
    'IFDIFF:PrepareNextIntegrationStage:InvalidIncrementDimension', ...
    msg, arrayStrJoin(size(x), ', ', '%d'), arrayStrJoin(size(increment), ', ', '%d'));
end

function e = invalidIncrementTypeError(increment)
msg = 'Invalid increment type: Increment must be numeric, but has type %s instead.\n';
e = MException('IFDIFF:PrepareNextIntegrationStage:InvalidIncrementType', msg, class(increment));
end

function e = infiniteIncrementError(increment)
msg = 'Infinite increment error: Increment must be finite, but is [%s] instead.\n';
e = MException('IFDIFF:PrepareNextIntegrationStage:InfiniteIncrement', msg, arrayStrJoin(increment, ', ', '%g'));
end
