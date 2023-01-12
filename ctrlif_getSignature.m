function [A1, A2, A3] = ctrlif_getSignature(datahandle, t, x)
% function that evaluates the rhs function to get the signature at t

data = datahandle.getData();
% get data for reading and writing
% disable switching point detection in ctrlif

data.caseCtrlif = 3; % case 3: getSignature
data.getSignature.ctrlifCounter = 0;

data.getSignature.switch_cond    = [];
data.getSignature.ctrlif_index   = [];
data.getSignature.function_index = {};

datahandle.setData(data);


% evaluate the function at the two borders of the switching interval
feval(...
    data.integratorSettings.preprocessed_rhs, ...
    datahandle, ...
    t, ...
    x, ...
    data.SWP_detection.parameters);


data = datahandle.getData();
index = 1:data.getSignature.ctrlifCounter;

A1 = data.getSignature.switch_cond(1,index);
A2 = data.getSignature.ctrlif_index(1,index);
A3 = data.getSignature.function_index(index,1);
end

