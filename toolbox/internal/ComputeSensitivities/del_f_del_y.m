function diff = del_f_del_y(datahandle, f, t, y, parameters, h)
%DEL_F_DEL_Y compute the partial derivative of a function (RHS, switching function, or jump function)
% w.r.t. y using finite differences. The function must accept the arguments (datahandle, t, y, parameters)
% and return a column vector.

dim_y = length(y);
function_value = f(datahandle, t, y, parameters);
diff = zeros(length(function_value), dim_y);

y_orig = y;
for i = 1:dim_y
    y(i) = y(i) + h(i);
    diff(:,i) = (f(datahandle, t, y, parameters) - function_value) / h(i);
    y(i) = y_orig(i);
end
end
