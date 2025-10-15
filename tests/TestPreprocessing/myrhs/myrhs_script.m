% names
name_part1 = 'myrhs';
% name_part2 = 'if';
% name_part2 = 'abs';
% name_part2 = 'min';
% name_part2 = 'sign';
name_part2 = 'difficult';
filename = strcat(name_part1, '_', name_part2);


% myrhs_mtree = mtreeplus(strcat(filename,'.m'), '-file');
% ~ = prepareDatahandleForIntegration(filename);
preprocessed_myrhs = preprocess(filename);


% get preprocessed function 
myrhs_mtree = preprocessed_myrhs.rhs{3};
preprocessed_str = tree2str(myrhs_mtree);
% write it to a file
output_filename = strcat(filename, '_preprocessed.m');
fileID = fopen(output_filename, 'w');
fprintf(fileID, '%s', preprocessed_str);
fclose(fileID);