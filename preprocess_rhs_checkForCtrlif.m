function preprocess_rhs_checkForCtrlif(preprocess) 
% solveODE would result in an error when there
% is absolutely no ctrlif in the code. 
% This problem occurs when the signature is empty. 

%  default value for ctrlif_index is 1
% i.e. if true then no ctrlif has been set so far. 
condition = preprocess.ctrlif_index == 1; 
if condition
    error('No line of code found, that could cause a switch.')
end 

end 