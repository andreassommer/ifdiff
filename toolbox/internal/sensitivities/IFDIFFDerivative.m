classdef IFDIFFDerivative < handle
    %IFDIFFDERIVATIVE - Interface for derivatives used by IFDIFF
    %
    %    Description
    %      Declares methods for computing directional derivatives of functions (in particular RHS, submodel, switching and jump functions)
    %      which return some quantity given a time point, state vector and parameter vector.
    %
    %    Methods
    %      dt/dy/dp - Compute directional derivative w.r.t. t/y/p for an arbitrary number of directions
    %
    %    See also IFDIFFDERIVATIVEFINITEDIFFERENCES


    methods (Abstract, Access=public)
        d = dt(this, t, y, p, v)
        d = dy(this, t, y, p, v)
        d = dp(this, t, y, p, v)
    end
end
