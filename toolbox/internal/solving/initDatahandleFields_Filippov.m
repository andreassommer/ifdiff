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

convexification.function_index = [];
convexification.t              = [];
convexification.alpha          = [];
sliding.convexification = convexification;
end
