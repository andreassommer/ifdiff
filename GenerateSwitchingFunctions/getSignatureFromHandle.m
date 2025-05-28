function signatures = getSignatureFromHandle(handles, cut_rhs_name, rhs_name)
% handles: switching functions
% function handle or cell array of function handles

names = cellfun(@func2str, handles, 'UniformOutput', false);
names = strcat(names, '.m');
signatures = unique(cellfun(@readSignatureFromFile, names, 'UniformOutput', false));

if cut_rhs_name
    k = length(rhs_name);
    cutname = @(name) name(k+2:end); % k+2 because rhs name and signature are seperated by a colon
    signatures = cellfun(cutname, signatures, 'UniformOutput', false);
end