function sliding = initDatahandleFields_Filippov(sliding)
%sliding = INITDATAHANDLEFIELDS_FILIPPOV()
%
%Initialize struct for Filippov mode handling in IFDIFF.
%
%INPUT/OUTPUT:
%   sliding - Struct used for Filippov mode handling in IFDIFF.
%       struct
%
%See also INITDATAHANDLEFIELDS.

sliding = extendODE_filippov_regime_cleanup(sliding);

convexification.t                  = [];
convexification.index              = [];
convexification.alpha              = [];
sliding.convexification = convexification;
end
