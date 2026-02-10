function [choiceIndex, choiceValue] = userchoice(choices, default)
% [choiceIndex, choiceValue] = userchoice(choices, default)
%
% Presents a numbered list of choices to the user.
% The chosen number and the value are returned.
%
% INPUT:    choices --> Cell array (of char arrays or strings) to be displayed 
%           default --> Index that is returned if user presses just Enter
%
% OUTPUT:   choiceIndex --> Chosen index by user
%           choiceValue --> Choice value associated to choiceIndex
%
%
% Andreas Sommer, Aug2024
% code@andreas-sommer.eu
%

% options must be cell string
assert(iscell(choices), 'Choices must be a cell string');
choices = cellfun(@convertStringsToChars, choices, 'UniformOutput', false);

% default is 1 if not specified
if (nargin < 2), default = 1; end

% ask user
choiceIndex = chooser(choices, default);
choiceValue = choices{choiceIndex};

end % of function

%% HELPERS

function numsel = chooser(choices, default)
   % show all options
   nchoices = length(choices);
   width = floor(log10(nchoices))+1;
   for i=1:length(choices)
      fprintf('%*d) %s\n', width, i, choices{i});
   end
   validchoice = false;
   query = sprintf('Choice: [%d] ', default);
   while ~validchoice
      sel = input(query, 's');
      numsel = str2double(sel);
      if isempty(sel), numsel = default; end
      if ( numsel >= 1 ) && ( numsel <= nchoices ) && ( mod(numsel,1) == 0 )
         validchoice = true;
      else
         fprintf('Invalid choice. Type one of the displayed numbers. Try again.\n');
      end
   end
end
