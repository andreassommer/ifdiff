function dx = preprocessing_badparsing_sign_rhs(t,x,p)
    dx = zeros(3,1);
    dx(1) = x(2);
    dx(2) = -x(1);
    if x(1) < -(p(1))  %% NOT WORKING:  if x(1) < -p(1)
        dx(3) = 0;
    else
        if x(1) > (p(1))
            dx(3) = 0;
        else
            if x(2) < 0
                dx(3) = -1;
            else
                dx(3) = 1;
            end
        end
    end
end