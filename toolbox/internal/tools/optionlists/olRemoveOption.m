function clearedOptions = olRemoveOption(optionlist, varargin)
   % clearedOptions = olRemoveOption(optionlist, name1, name2, ...)
   %
   % Removes specified properties/options (and the associated value) from optionlist.
   %
   % INPUT:    optionlist --> a cell array of key-value-pairs
   %                nameN --> keys to be removed
   % OUPUT: cleardoptions --> processed optionlist
   %
   % Author: Andreas Sommer, Sep2016, Jul2024
   % andreas.sommer@iwr.uni-heidelberg.de
   % code@andreas-sommer.eu
   %
   %
   % History:
   %      Mar2021: Renamed from removeOptions to removeOption to unify naming
   %      Jul2024 --> renamed to ol* scheme

   % if no options are to be deleted, just return the given optionlist
   if (nargin==1)
      clearedOptions = optionlist;
      return
   end

   % ensure optionlist is a valid optionlist
   olAssertOptionlist(optionlist);

   % assert that varargin is a cell array of strings
   if ~iscellstr(varargin)        %#ok<ISCLSTR>  % really check for *cell* string
      disp('Problem detected:')
      disp(varargin)
      error('Invalid key list!')
   end

   % prepare new optionlist
   clearedOptions = {};


   % just check the keys in optionlist
   for j = 1:2:length(optionlist)
      removeit = false;

      % walk through the varargins
      for k = 1:length(varargin)
         if strcmpi(optionlist{j},varargin{k})
            removeit = true;  % marker that we remove something
            break;
         end
      end

      % keep or remove it
      if removeit
         continue
      else %#ok<*AGROW>
         clearedOptions{end+1} = optionlist{j};   % copy key
         clearedOptions{end+1} = optionlist{j+1}; % copy value
      end

   end

end