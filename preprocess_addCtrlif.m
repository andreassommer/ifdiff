function [mtreeobj, ctrlif_index] = preprocess_addCtrlif(mtreeobj, ctrlif_index) 
% Replace nondifferentiabilities in RHS with ctrlif ('control-if'). ctrlif is a function that takes the
% condition of an if. In the simplest case, it just returns true or false depending on the condition - in this
% case, the preprocessed RHS is equivalent to the original. It can also be set to store the true/false value
% ('signature') and to later return the stored true/false value, allowing integration with a fixed model even
% after passing the switching point, while monitoring if the actual true/false value changed. ctrlif is also
% used for constructing switching functions after a switch is found.
% if/else, min, max, abs/ sign, and IIf can be replaced by ctrlif.
% State jumps, signaled by the dummy function ifdiff_statejump, are also translated to ctrlif.

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

% State jumps: replace e.g.
% ifdiff_jumpif(a - b, 1, 20)
%
% with
% 
% ctrlif(a - b >= 0, true, false, ...)
% ctrljump(20, 0, ...)
% 
% the ctrljump is never executed, it only serves to find the correct ctrlif for the later task of constructing the
% jump function
[mtreeobj, ctrlif_index] = mtree_replaceJumpifByCtrlif(mtreeobj, ctrlif_index);
end