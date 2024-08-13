function sensData = generateSensData(n)
    fieldnames_sensData = {'timepoints', 'modelNum', 'Gy_t_ts', 'Gy', 'Gp'};
    sensData = generateStructArray(fieldnames_sensData, n);
end

