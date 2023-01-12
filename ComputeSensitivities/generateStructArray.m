function structarray = generateStructArray(fieldnames, n)
   % structarray = generateStructArray(fieldnames, n)
   %
   % Generates struct array of the length n with the given fieldnames. 
   %
   % INPUT: fieldnames - cell-array with the fieldnames
   %        n          - length of the struct array that has to be generated
   %
   % OUTPUT: structarray: struct array of the length n with the given fieldnames
   
   arglist = cell(2*length(fieldnames), 1);
   arglist(1:2:end) = fieldnames(:);
   s = struct(arglist{:});
   structarray(n) = s;   
end