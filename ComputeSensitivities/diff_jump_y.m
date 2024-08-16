function djump = diff_jump_y(datahandle, jumpFunction, t, y, parameters, h)
%DIFF_JUMP_Y compute the partial derivative of a jump function w.r.t. y using finite differences.
    dim_y = length(y);
    unit = eye(dim_y);
    djump = zeros(dim_y);
    
    for i = 1:dim_y
        djump(:,i) = ( jumpFunction(datahandle, t, y+h.*unit(:,i), parameters) - jumpFunction(datahandle, t, y, parameters) ) / h(i);
    end
end