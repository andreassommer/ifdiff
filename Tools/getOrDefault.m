function value = getOrDefault(s, key, default)
% Get a value from a struct if the key is present, or a default value otherwise
    if isfield(s, key)
        value = s.(key);
    else
        value = default;
    end
end