function preprocessed = preprocess_fcnInRhs(preprocessed)
% preprocess functions that are called in the rhs (first functions;
% filename)
% preprocess them (adapt all fcn calls & set ctrlif % set ctrlif and function index)

if isempty(preprocessed.fcn)
    % nothing to do
    return
end

% replace abs, min, max, iif etc. by ctrlif
% add preprocessed_ to function name and add datahandle/function_handle as input variable

l = size(preprocessed.fcn, 2);
fcn = preprocessed.fcn;

containsNondifferentiability = zeros(1, l);
occursUnignored              = zeros(1, l);
for i = 1:l
    
    mtree_fcn = mtreeplus([preprocessed.fcn{1,i}, '.m'], '-file', '-comments');
    % First, replace elseif by else-if
    mtree_fcn = mtree_replaceElseif(mtree_fcn);
    fcn{4,i} = [mtree_getIgnoredIfs(mtree_fcn), mtree_getJumpUpdateIgnores(mtree_fcn)];
    [mtree_fcn, ctrlif_new] = preprocess_addCtrlif(mtree_fcn, preprocessed.ctrlif_index, fcn{4,i});

    % check whether any ctrlif has been set. If not, it has no nondifferentiabilities and does not need to
    % be preprocessed
    containsNondifferentiability(i) = preprocessed.ctrlif_index ~= ctrlif_new;
    % check if all calls to the function are ignored. If so, it should not be preprocessed.
    callsInRhs = find(mtfind(preprocessed.rhs{3,1}, 'Fun', preprocessed.fcn{1, i}).IX);
    occursUnignored(i) = ~all(ismember(callsInRhs, preprocessed.rhs{4, 1}));

    preprocessed.ctrlif_index = ctrlif_new;
    fcn{2,i} = preprocess_setUpNewFcnName(fcn{1,i});
    [mtree_fcn, ~] = preprocess_editFunctionHead(mtree_fcn);
    fcn{3,i} = mtree_fcn;
end

% If a function f has no nondifferentiabilities, but it calls another function g that does, then f should also be
% preprocessed - even if only so that the calls to g can be replaced by calls to preprocessed_g.
% Similarly, a function whose calls in the RHS are all ignored may still be relevant if it is called transitively
% by another function. The following loop identifies such transitive cases. It only goes one level deep, however.
% meaning, if f and g both contain no ctrlif, but g calls a function h that does, then too bad.
includeInPreprocessing = occursUnignored & containsNondifferentiability;
for i = 1:l
    if ~occursUnignored(i)
        continue
    end
    for j = 1:l
        if i == j || ~containsNondifferentiability(j)
            continue
        end
        callsInFcn = find(mtfind(fcn{3,i}, 'Fun', fcn{1, j}).IX);
        allOccurrencesIgnored = all(ismember(callsInFcn, fcn{4, i}));
        if ~allOccurrencesIgnored
            includeInPreprocessing(i) = 1;
            includeInPreprocessing(j) = 1;
        end
    end
end

preprocessed.fcn = fcn(:, includeInPreprocessing);
end
