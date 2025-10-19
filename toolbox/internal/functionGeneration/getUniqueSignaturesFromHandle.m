function signatures = getUniqueSignaturesFromHandle(handles)
% INPUT:
% 'handles':        switching functions
%                       function handle or cell array of function handles
%
% OUTPUT:
% 'signatures'      the unique signatures of the switching functions contained in 'handles'.
%                       cell array of char arrays

names = cellfun(@func2str, handles, 'UniformOutput', false);
names = strcat(names, '.m');
signatures = unique(cellfun(@readSignatureFromFile, names, 'UniformOutput', false));