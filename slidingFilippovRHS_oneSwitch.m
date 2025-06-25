function dy = slidingFilippovRHS_oneSwitch(datahandle, signature_fplus, signature_fminus, switchingFunction,t,y,p)
% Computes a Filippov right-hand-side w.r.t. the given 'ctrlifCounter', 
% i.e., a convex-combination of the two models where the associated 
% ctrlif evaluates to 0 and 1, respectively. 
% Read [1] or [2, Chapter 1] for mathematical details.
% 
% INPUT:
%   'datahandle'        --> Datahandle for a switched system.
%                               handle
%   'signature_fplus'   --> signature corresponding to fplus in the
%                           sliding RHS formula
%                               struct
%   'signature_fminus'  --> signature corresponding to fminus
%                               struct
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

% evaluate RHS for signature where chattering switchingFunction is positive
ctrlif_index_fminus     = signature_fminus.ctrlif_index;
function_index_fminus   = signature_fminus.function_index;
switch_cond_fminus      = signature_fminus.switch_cond;
f_minus = evaluateRHSForSignature(datahandle, t, y, p, ctrlif_index_fminus, function_index_fminus, switch_cond_fminus);

% evaluate RHS for signature where chattering switchingFunction is negative
ctrlif_index_fplus      = signature_fplus.ctrlif_index;
function_index_fplus    = signature_fplus.function_index;
switch_cond_fplus       = signature_fplus.switch_cond;
f_plus  = evaluateRHSForSignature(datahandle, t, y, p, ctrlif_index_fplus, function_index_fplus, switch_cond_fplus);


FDstep = generateFDstep(length(y), length(p)); % TODO use relative finite differences (consider typical values of y and p)
n = del_f_del_y(datahandle, switchingFunction, t, y, p, FDstep.y);
% n (= d/dy switchingFunction) is an outer normal of switching manifold that we want to slide on

n_dot_fplus  = dot(n,f_plus);
n_dot_fminus = dot(n,f_minus);

% assemble alpha
alpha = n_dot_fplus/(n_dot_fplus-n_dot_fminus);

% SANITY CHECK
% dot(n,f_plus) and dot(n, f_minus) can't have the same sign. otherwise we 
% are not in sliding mode anymore and can not rely on the previous formula for alpha
if n_dot_fplus < 0 && n_dot_fminus < 0
    % neg: f_plus, f_minus point into {swFct<0}, continue with f_minus
    alpha = 1;
end

if n_dot_fplus > 0 && n_dot_fminus > 0
    % pos: n points into {swFct>=0}, so f_plus,f_minus point into {sigma>0}.
    alpha = 0;
end

% write alpha into datahandle
data = datahandle.getData();
data.sliding.alpha_last = alpha;
datahandle.setData(data);

dy = alpha*f_minus + (1-alpha)*f_plus;

end