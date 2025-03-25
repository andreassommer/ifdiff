function name = getExportFunctionName(rhsName, exportIndex)
DELIMITER = '_';
name = [rhsName, DELIMITER, num2str(exportIndex)];
end
