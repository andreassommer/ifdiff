function name = createSwitchingFcnNewName(hash, rhs_name)
    DELIMITER = '_';
    config = makeConfig();

    name = [...
        config.switchingFunctionNamePrefix, ...
        rhs_name, ...
        DELIMITER, hash ];
end

