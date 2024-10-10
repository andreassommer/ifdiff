function diff = del_f_del_t(datahandle, f, t, y, parameters, h)
%DEL_F_DEL_T compute the partial derivative of a function (RHS, switching function, or jump function)
% w.r.t. time using finite differences. The function must accept the arguments (datahandle, t, y, parameters)
% and return a column vector.
    diff = (f(datahandle, t+h, y, parameters) - f(datahandle, t, y, parameters)) / h;
end