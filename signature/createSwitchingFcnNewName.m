function name = createSwitchingFcnNewName(hash, rhs_name)
    DELIMITER = '_';
    config = makeConfig();

    name = [...
        config.switchingfunction.prefix_name, ...
        DELIMITER, rhs_name, ...
        DELIMITER, hash ];
end

