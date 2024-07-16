function [mtreeobj, ctrlif_index] = preprocess_addCtrlif(mtreeobj, ctrlif_index) 
% Consider a rhs (right-hand-side) function of an ODE. 
% First it creates a Mtree of the function. The mtree is modified s.t. all Max, Min,
% Abs, Sign, If, IIf function calls are exchanged by ctrlif ('control-if') function calls. 
% 
% The ctrlif structure is essential for monitoring all possible switches
% and to detect and adapt the calculation of the solution, as well as the
% exporting of the switching functions. 
%
% 
%
% INPUT:
% 'filename':   the name of the file that contains the righhandside
%               function
%
%
% OUTPUT:
% 'datahandle';
%  with mtree object and Ctrlif functions as condition for if statements:
%          .mtreeobj:   the returned mtree object which then
%                       contains CtrlifRe03 function calls - ready
%                       for switching point detection



% adjust If conditions s.th. it is compatible with the ctrlif structure,
% e.g.
% if a >= b 
% ...
% end           
%
% is changed to: 
% 
% cond = ctrlif(a - b >= 0, a, b, ...) 
% if cond
% ...
% end 
[mtreeobj, ctrlif_index] = mtree_replaceIfByCtrlif(mtreeobj, ctrlif_index);



% replace Abs by Crtlif, 
% e.g.
% b = abs(a); 
% 
% is changed to
% 
% temp_abs_value = a; 
% b = ctrlif(temp_abs_value >= 0, temp_abs_value, -temp_abs_value, ...)
[mtreeobj, ctrlif_index] = mtree_replaceAbsByCtrlif(mtreeobj, ctrlif_index);

% replace sign by ctrlif
% e.g.
% a = sign(b) 
% 
% is changed to
% 
% temp_sign_value = a; 
% b = ctrlif(temp_abs_value >= 0, 1, -1, ...) 
% 
% note that sign(0) = 0 is modified to sign(0) = 1; user will be warned
[mtreeobj, ctrlif_index] = mtree_replaceSignByCtrlif(mtreeobj, ctrlif_index);


% replace Max, Min by Ctrlif
% e.g.
% c = max(a,b) 
%
% is changed to 
% 
% temp_arg1 = a; 
% temp_arg2 = b; 
% c = ctrlif( temp_arg1 - temp_arg2 >= 0, temp_arg1, temp_arg2, ...)
[mtreeobj, ctrlif_index] = mtree_replaceMaxByCtrlif(mtreeobj, ctrlif_index);
[mtreeobj, ctrlif_index] = mtree_replaceMinByCtrlif(mtreeobj, ctrlif_index);


end 























