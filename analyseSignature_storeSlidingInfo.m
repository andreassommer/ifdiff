function convexification = analyseSignature_storeSlidingInfo(t, x, datahandle)
% Stores sliding info into convexification, which is read from 'datahandle'
% and then modified.
%
%
% INPUT:
% 't'           the last successful integration step(s); time variable
%                   double or array of doubles
% 'x'           the last successful integration step(s); state variable
%                   array of doubles
% 'datahandle'  datahandle
%                   handle
%
% OUTPUT:
% 'convexification' the updated sliding information
%                       struct
%

data = datahandle.getData();
convexification = data.sliding.convexification;
convexification.t       = [convexification.t, t];

if isempty(data.sliding.filippov_rhs)
    % Not in filippov mode, add NaN/entry entries.
    convexification.index   = [convexification.index, NaN(1,length(t))];
    convexification.alpha   = [convexification.alpha, NaN(1,length(t))];
    convexification.signature_fplus  = [convexification.signature_fplus,  cell(1,length(t))]; % write empty cells
    convexification.signature_fminus = [convexification.signature_fminus, cell(1,length(t))];
    return
end

% We don't want to redundantly store the signature many times. So we store 
% it once and write a pointer in form of an index into all following entries
k = length(convexification.signature_fplus);
if k==0 || ~isscalar(convexification.signature_fplus{end})
    pointer = k+1;
    convexification.signature_fplus  = [convexification.signature_fplus,  data.sliding.signature_fplus,  repmat({pointer}, 1,length(t)-1)];
    convexification.signature_fminus = [convexification.signature_fminus, data.sliding.signature_fminus, repmat({pointer}, 1,length(t)-1)];
else
    % arrays have a pointer as the last entry, so we just add copies of it
    convexification.signature_fplus  = [convexification.signature_fplus,  repmat(convexification.signature_fplus(end),  1,length(t))];
    convexification.signature_fminus = [convexification.signature_fminus, repmat(convexification.signature_fminus(end), 1,length(t))];
end

% t can be vector-valued, but the Filippov-RHS can only save the alpha from
% the latest evaluation, so we have to recompute it instead of reading it from
% 'data.sliding' in that case. Note that we can also not assume
% data.sliding.alpha_last to be corresponding to the last entry in t if
% it's a vector, see the comment about evaluating the RHS in analyseSignature.
k = length(t);
if k==1
    alpha = data.sliding.alpha_last;
else
    % k>1
    alpha = NaN(1,k);
    for i=1:length(t)
        unused = data.sliding.filippov_rhs(datahandle, t(i), x(:,i), data.SWP_detection.parameters); %#ok<NASGU> 
        alpha(i) = datahandle.getData().sliding.alpha_last;
    end
end
convexification.alpha   = [convexification.alpha, alpha];

index = datahandle.getData().sliding.index;
convexification.index   = [convexification.index, repmat(index, 1,length(t))];

end