function cutSteps_convexification(datahandle, t_cut)
% cutSteps_convexification(datahandle, t_cut)
%
% Cuts off all info for steps past 't_cut' in datahandle.sliding.convexification
%
% INPUT:
%   datahandle:      datahandle, contains the convexification info to be cut
%                       handle
%
%   t_cut:          All steps past t_cut are cut.
%                       scalar
%
% OUTPUT:
%   None.

data = datahandle.getData();

convexification_t                   = data.sliding.convexification.t;
data.sliding.convexification.t      = data.sliding.convexification.t(convexification_t<=t_cut);
data.sliding.convexification.index  = data.sliding.convexification.index(convexification_t<=t_cut);
data.sliding.convexification.alpha  = data.sliding.convexification.alpha(convexification_t<=t_cut);
data.sliding.convexification.signature_fplus    = data.sliding.convexification.signature_fplus(convexification_t<=t_cut);
data.sliding.convexification.signature_fminus   = data.sliding.convexification.signature_fminus(convexification_t<=t_cut);

datahandle.setData(data);

end