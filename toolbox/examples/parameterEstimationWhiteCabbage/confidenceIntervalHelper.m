function ci = confidenceIntervalHelper(beta, resid, varargin)
    % confidenceIntervalHelper  Computes confidence intervals like nlparci
    %
    %
    % varargin: 

    J = [];
    Sigma = [];
    alpha = 0.05;
    if nargin>=3 && ischar(varargin{1})
        okargs =   {'jacobian' 'covariance' 'alpha'};
        defaults = {[]         []           0.05};
        [eid emsg J Sigma alpha] = statgetargs(okargs,defaults,varargin{:});
        if ~isempty(eid)
            error(sprintf('stats:nlparci:%s',eid),emsg);
        end
    else
        % CI = NLPARCI(BETA,RESID,J,ALPHA)
        if nargin>=3, J = varargin{1}; end
        if nargin>=4, alpha = varargin{2}; end
    end
    if nargin<=2 || isempty(resid) || (isempty(J) && isempty(Sigma))
        error('stats:nlparci:TooFewInputs',...
            'Requires BETA, RESID, and either J or SIGMA.');
    end;
    if ~isreal(beta) || ~isreal(J)
        error('stats:nlparci:ComplexParams',...
            ['Cannot compute confidence intervals for complex parameters.  You must\n' ...
            'reparameterize the model into its real and imaginary parts.']);
    end
    if isempty(alpha)
        alpha = 0.05;
    elseif ~isscalar(alpha) || ~isnumeric(alpha) || alpha<=0 || alpha >= 1
        error('stats:nlparci:BadAlpha',...
            'ALPHA must be a scalar between 0 and 1.');
    end


    % Calculate confidence interval
    delta = se * tinv(1-alpha/2,v);
    ci = [(beta(:) - delta) (beta(:) + delta)];   
end