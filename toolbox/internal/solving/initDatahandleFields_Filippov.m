function sliding = initDatahandleFields_Filippov()
%sliding = INITDATAHANDLEFIELDS_FILIPPOV()
%
%Initialize struct for Filippov mode handling in IFDIFF.
%
%OUTPUT:
%   sliding - Struct used for Filippov mode handling in IFDIFF.
%       struct
%
%See also INITDATAHANDLEFIELDS.

sliding = extendODE_filippov_regime_cleanup(struct());

% if true: convexification parameters and signatures are stored for every integration step
sliding.storeSlidingInfo = false;

convexification.t                  = [];
convexification.index              = [];
convexification.alpha              = [];
convexification.signature_fminus   = {};
convexification.signature_fplus    = {};
sliding.convexification = convexification;
end
