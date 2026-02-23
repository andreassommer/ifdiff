function dy = slidingFilippovRHS_oneSwitch(datahandle, signatures, switchingFunction, t, y, p)
% Computes a Filippov right-hand-side w.r.t. the given 'ctrlifCounter',
% i.e., a convex-combination of the two models where the associated
% ctrlif evaluates to 0 and 1, respectively.
% Read [1] or [2, Chapter 1] for mathematical details.
%
% INPUT:
%   'datahandle'        --> Datahandle for a switched system.
%                               handle
%   'signatures'        --> signatures whose convex-combination is to be computed
%                           Note: first signature should have positive switching function value
%                               1x2 BranchingSignature
%   'switchingFunction' --> Switching function of the switch that is
%                           to be put in sliding mode.
%                               function handle
%   't'                 --> time, passed to the preprocessed RHS
%                               scalar
%   'y'                 --> state, passed to preprocessed RHS
%                               scalar or array
%   'p'                 --> parameters, passed to preprocessed RHS
%                               scalar or array
%
% OUTPUT:
%    'dy'                --> Value of the Filippov-RHS, determined as
%                            described above.
%                               scalar or array
%
% Author: Michael Strik, Jun2024
% Email:  michael.strik@stud.uni-heidelberg.de
%         michi.strik@gmail.com
%
% [1] A.F. Filippov. Differential Equations with Discontinuous Right
% Hand Side. Kluwer Academic Publishers, Dordrecht, Boston, London, 1988.
% [2] A. Meyer. Numerical Solution of Optimal Control Problems with
% Explicit and Implicit Switches. PhD thesis, Ruprecht-Karls-Universität
% Heidelberg, 2020.

% Evaluate RHS for chattering signatures where switching function is positive/negative.
% Important: Assume that first signature in signatures is the positive one (has to be ensured by caller)!
f_plus  = evaluateRHSForSignature(datahandle, t, y, p, signatures(1));
f_minus = evaluateRHSForSignature(datahandle, t, y, p, signatures(2));

% n (= d/dy switchingFunction) is an outer normal of switching manifold that we want to slide on
% TODO: use relative finite differences (consider typical values of y and p)
FDstep = generateFDstep(length(y), length(p));
n = del_f_del_y(datahandle, switchingFunction, t, y, p, FDstep.y);
n_dot_fplus  = dot(n, f_plus);
n_dot_fminus = dot(n, f_minus);

% The dot products dot(n, f_plus) and dot(n, f_minus) can't have the same sign.
% Otherwise we are not in sliding mode anymore and can not rely on the standard formula for alpha.
if n_dot_fplus < 0 && n_dot_fminus < 0
    % Neg: f_plus and f_minus point into {swFct<0}, continue with f_minus
    alpha = 1;
elseif n_dot_fplus > 0 && n_dot_fminus > 0
    % Pos: f_plus and f_minus point into {swFct>0}, continue with f_plus
    alpha = 0;
else
    % Compute alpha as usual
    alpha = n_dot_fplus / (n_dot_fplus-n_dot_fminus);
end

% Store alpha in datahandle
data = datahandle.getData();
data.sliding.alpha_last = alpha;
datahandle.setData(data);

% Compute sliding mode RHS
if isfinite(alpha)
    dy = alpha*f_minus + (1-alpha)*f_plus;
else
    warnAlphaNotFinite(t, y, p);
    dy = repmat(1e100, 1, length(y));
end
end


%% Warnings
function warnAlphaNotFinite(t, y, p)
id = 'IFDIFF:Filippov:AlphaNotFinite';
msg = [ ...
    'Filippov sliding mode RHS encountered non-finite convexification parameter at\nt=%g,\ny=[%s],\np=[%s].\n', ...
    'Returning very large finite value instead to force step size reduction and prevent NaN-poisoning.\n', ...
    'Consider checking the domain of your RHS for undefined regions or reducing the integrators maximum step size.' ...
    ];
warning(id, msg, t, arrayStrJoin(y, ',', '%g'), arrayStrJoin(p, ',', '%g'));
end
