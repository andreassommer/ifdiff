function ifdiff_jumpif(switchingFunction, direction, increment)
    % Use this function in a RHS to signal that the state should jump when the value `switchingFunction` hits zero.
    % direction can be -1, 0, or 1, determining whether to jump when the state goes from negative to positive (1),
    % positive to negative (-1), or both (0).
    % This function is never evaluated, it is replaced during preprocessing.
end