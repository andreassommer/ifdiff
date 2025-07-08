function signature = readSignatureFromFile(filepath)
%signature = READSIGNATUREFROMFILE(filepath)
%
%Read the string representation of a signature from a file.
%Used to verify if a switching function found via hash is actually the correct one or the result of a hash collision.
%
%INPUT:
%   filepath - Path to the file containing the signature.
%   The first line of the file should contain a comment with the signature, i.e. %<signature>\n
%       char array
%
%OUTPUT:
%   signature - String representation of the signature found in the file.
%       char array

file = fopen(filepath);
% Note: fgetl removes the newline character at the end of the line.
signature = fgetl(file);
% Remove the first char (%) to get the signature string
signature = signature(2:end);
fclose(file);
end
