function new_name = setUpSwitchingFunction_newName(switchingFcn, x)
% assemble name of new function
%
% name is assembled as following:
% prefix, _ , XYZ, _ , name of the function
%
% example:
% sw_123_myfunction_name; switching function for rhs "myfunction_name"
% considering the first switch and here where detected 2 or more switches
% at one integration step. It consideres thereby the 2nd. It is the third
% function within this switch, i.e. there must exist sw_121_myfunction_name and sw_122_myfunction_name as well.

fun_index = num2str(x); 

config = makeConfig();

new_name = [config.switchingFunctionNamePrefix, ...
    switchingFcn.rhs_name_original, ...
    '_', ... 
    num2str(switchingFcn.uniqueSwEnumeration), ...
    fun_index(~isspace(fun_index))];


end