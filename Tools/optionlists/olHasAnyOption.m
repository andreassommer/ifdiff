function foundKey = olHasAnyOption(optionlist, varargin)
%OLHASANYOPTION Check if optionlist has any of the given keys.
%   foundKey = OLHASANYOPTION(optionlist, searchKey1, ...)
%
%   INPUT
%   optionlist : a valid optionlist whose keys will be searched
%   varargin : contains keys to search for as char arrays
%
%   OUTPUT
%   foundKey : First searchKey that was found in optionlist.
%              Empty char array '' if no searchKey was found.


% Validate input
olAssertOptionlist(optionlist);
searchKeys = varargin;
assert(iscellstr(searchKeys)); %#ok<ISCLSTR>

foundKey = '';
for idx=1:length(searchKeys)
    if olHasOption(optionlist, searchKeys{idx})
        foundKey = searchKeys{idx};
        return
    end
end
end
