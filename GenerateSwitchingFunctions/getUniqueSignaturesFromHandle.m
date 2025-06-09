function signatures = getSignatureFromHandle(handles, rhs_name)
% INPUT:
% 'handles':        switching functions
%                       function handle or cell array of function handles
%
% 'cut_rhs_name'    flag: if true, 
%                       boolean
%
% 'rhs_name'        Name of the right-hand-side function. Gets cut off the
%                   signature char arrays. If 'rhs_name' is an empty char
%                   array, nothing is cut off from the signatures.
%                       char array
% OUTPUT:
% 'signatures'      the signatures of the switching functions contained in 'handles'.
%                       cell array of char arrays
%
% Author: Michael Strik, May2025
% Email: michael.strik@stud.uni-heidelberg.de
%        michi.strik@gmail.com
                   
names = cellfun(@func2str, handles, 'UniformOutput', false);
names = strcat(names, '.m');
signatures = unique(cellfun(@readSignatureFromFile, names, 'UniformOutput', false));

if ~isempty(rhs_name)
    k = length(rhs_name);
    cutname = @(name) name(k+2:end); % k+2 because rhs name and signature are seperated by a colon
    signatures = cellfun(cutname, signatures, 'UniformOutput', false);
end