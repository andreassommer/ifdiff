function dx = soll_test_fun_1(datahandle,t,x,p)
    dx = zeros( 2, 1 );
    dx( 1 ) = 0.01 * t .^ 2 + x( 2 ) .^ 3;
    % Testkommentar 1
    ifdiff_condition_1_0_value =  x( 1 ) - (p( 1 )) >= 0;
    ifdiff_condition_1_0_logical = ifdiff_condition_1_0_value >= 0;
    ifdiff_condition_1_0_branch = ctrlif(ifdiff_condition_1_0_logical, false, true, 1, 0, datahandle );
    if ifdiff_condition_1_0_branch
        dx( 2 ) = 0;
    else
        conditionValue = ctrlif( x( 1 ) - (p( 1 ) + 0.5)>=0, false, true, 2, 0, datahandle );
        if conditionValue
            dx( 2 ) = 5;  % Testkommentar 2
        else  % Testkommentar 3
            dx( 2 ) = 0;
        end
    end
end

