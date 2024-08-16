function djump = diff_jump_p(datahandle, jumpFunction, t, y, parameters, h)
%DIFF_JUMP_P Compute the partial derivative of a jump function w.r.t. parameters using finite differences
    dim_y = length(y);
    dim_p = length(parameters);
    unit = eye(dim_p);
    djump = zeros(dim_y, dim_p);
    
    for i = 1:dim_p
        djump(1,i) = (jumpFunction(datahandle, t, y, parameters + h.*unit(:,i)) - jumpFunction(datahandle, t, y, parameters) ) / h(i);
    end
end

