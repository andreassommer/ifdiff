function diff = del_f_del_p(datahandle, f, t, y, parameters, h)
%DEL_F_DEL_P Compute the partial derivative of a function (RHS, switching function, or jump function)
% w.r.t. parameters using finite differences. The function must accept the arguments (datahandle, t, y, parameters)
% and return a column vector.
    dim_p = length(parameters);
    unit = eye(dim_p);
    function_value = f(datahandle, t, y, parameters);
    diff = zeros(length(function_value), dim_p);

    for i = 1:dim_p
        diff(:,i) = (f(datahandle, t, y, parameters + h.*unit(:,i)) - function_value) / h(i);
    end
end

