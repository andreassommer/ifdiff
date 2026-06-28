classdef IFDIFFDerivative < handle
    methods (Abstract, Access=public)
        d = dt(this, t, y, p, v)
        d = dy(this, t, y, p, v)
        d = dp(this, t, y, p, v)
    end
end
