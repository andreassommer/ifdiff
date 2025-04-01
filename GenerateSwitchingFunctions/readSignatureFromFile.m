function signature = readSignatureFromFile(filepath)
% Assuming first line contains a comment with the signature, i.e. %<signature>\n
file = fopen(filepath);
signature = fgetl(file);
% Remove the first char (%) to get the signature string
signature(1) = [];
fclose(file);
end
