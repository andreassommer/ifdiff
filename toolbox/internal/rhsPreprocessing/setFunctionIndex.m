function i = setFunctionIndex(in1, in2)
% function to update the function index during a computation of the rhs 
% INPUT: new: new function index
% varargin: old funciton index, if there is no old one (in the rhs, first
% funciton index), then create new vector. 
% 
% OUTPUT: function_index as vector (1xN), tells you in which function is placed the swtich that caused
% the switch (part of signature) 
% 

% function function can be improved for efficency resasons later if
% required

if (in2 == -1)
    i = in1;
else
    % in2 = varargin{1}; 
    i = [in1, in2];
end


end









