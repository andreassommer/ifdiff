function results = mapOptionlist(mapfn, optionlist)
    %MAPOPTIONLIST Apply a function to every key-value pair of an optionlist, returning a cell array of the results
    % The function must be binary, taking the key as its first argument and value as its second.
    assertOptionlist(optionlist);

    results = cell(1, length(optionlist)/2);
    for i = 1:length(results)
        results{i} = mapfn(optionlist{2*i-1}, optionlist{2*i});
    end
end

