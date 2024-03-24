function newOptions = setOption(optionlist, varargin)
   % newOptions = setOption(optionlist, name1, val1, name2, val2, ...)
   %
   % Sets the specified properties/options and the associated value in propertylist.
   % If the option/property key is not yet in optionlist, it is automatically added.
   %
   % INPUT: optionlist --> a cell array of key-value-pairs
   %             nameN --> keys to be added
   %              valN --> values to be added
   % OUPUT: newOptions --> processed optionlist
   %
   % Copyright (c) 2016, Andreas Sommer
   % andreas.sommer@iwr.uni-heidelberg.de
   % mail@andreas-sommer.eu

   % Sep2016, andreas.sommer@iwr.uni-heidelberg.de
   
   % ensure optionlist and varargin are an optionlists
   assertOptionlist(optionlist);
   assertOptionlist(varargin);
   
   % walk through the varargin-optionlist
   for k = 1:2:length(varargin)
      key = varargin{k};
      val = varargin{k+1};
   
      % walk through the optionlist and set the option value
      updated = false;
      for j = 1:2:length(optionlist)
         if strcmpi(optionlist{j},key)
            optionlist{j+1} = val;
            updated = true;
            break
         end
      end
      
      % if optionlist was not updated, add the key-value-pair at the end
      if ~updated
         optionlist{end+1} = key; %#ok<AGROW>
         optionlist{end+1} = val; %#ok<AGROW>
      end
   end
   
   % return
   newOptions = optionlist;
   
end