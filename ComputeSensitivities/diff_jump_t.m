function djump = diff_jump_t(datahandle, jumpFunction, t, y, parameters, h_t)
%DIFF_JUMP_T Compute the partial derivative of a jump function w.r.t. time using finite differences
    djump = (jumpFunction(datahandle, t+h_t, y, parameters) - jumpFunction(datahandle, t, y, parameters) ) / h_t;
end

