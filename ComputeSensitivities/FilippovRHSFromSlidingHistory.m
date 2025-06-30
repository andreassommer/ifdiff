function dy = FilippovRHSFromSlidingHistory(datahandle, t, x, p)

data = datahandle.getData();
convexification = data.sliding.convexification;
% 

if t<convexification.t(1) || isnan(convexification.alpha(1))
    dy = data.integratorSettings.preprocessed_rhs(datahandle, t, x, p);
    return
elseif t<convexification.t(1) 
    error(['Solution seems to start in Filippov mode, ' ...
        'but convexification data is missing for the start of the solution interval.\n '])
end

if t>convexification.t(end)
    error('t out of bounds.\n');
end

t_history = convexification.t;
% search t1,t2 such that t is in [t1,t2)
for j=2:length(t_history)
    t2 = t_history(j);
    if t2 > t
        t1 = t_history(j-1);
        i= j-1;
        break;
    end
end

sliding_index_t1 = convexification.index(i);
sliding_index_t2 = convexification.index(i+1);

if ~isnan(sliding_index_t1) && ~isnan(sliding_index_t2)
    s = (t-t1)/(t2-t1);
    alpha_interp = (1-s)*convexification.alpha(i)+s*convexification.alpha(i+1);

    % compute f_plus
    signature_fplus = convexification.signature_fplus;
    f_plus  = evaluateRHSForSignature(datahandle, t, x, p, ...
        signature_fplus.ctrlif_index, signature_fplus.function_index, signature_fplus.switch_cond_fplus);

    % compute f_minus
    signature_fminus = convexification.signature_fminus;
    f_minus  = evaluateRHSForSignature(datahandle, t, x, p, ...
        signature_fminus.ctrlif_index, signature_fminus.function_index, signature_fminus.switch_cond_fplus);

    dy = alpha_interp*f_minus + (1-alpha)*f_plus;
else
    dy = data.integratorSettings.preprocessed_rhs(datahandle, t, x, p);
end
