function flag = make_mtreeplus(varargin)
% Generate mtreeplus from Matlab's original mtree implementation
% 
% INPUT:   [none] --> search Matlab's mtree, copy to mtreeplus and patch file
% 
% OUTPUT:  flag  -->  true if successful
%                     false on failure
%
% Andreas Sommer, 2020
% andreas.sommer@iwr.uni-heidelberg.de
% email@andreas-sommer.eu
%


% default flag: failure
flag = false;

% set some helpers/constants
MTREE_STRING         = 'mtree';
MTREE_FILENAME       = 'mtree.m';
MTREEPLUS_STRING     = 'mtreeplus';
MTREEPLUS_FILENAME   = 'mtreeplus.m';
MTREEPLUS_FOLDERNAME = '@mtreeplus';


% 1) identify source and destination paths
% 2) copy source to destination
% 3) generate/patch mtreeplus


% ensure that the current functions runs in working directory
[maker_path, maker_file, ~] = fileparts(mfilename('fullpath'));
if ~strcmp(maker_path, pwd())
   disp('Please call %s from inside its home directory %s', maker_file, maker_path)
   return
end


% setup path for mtreeplus
mtreeplus_path = fullfile(maker_path, MTREEPLUS_FOLDERNAME, filesep);
mtreeplus_file = fullfile(mtreeplus_path, MTREEPLUS_FILENAME);


% if mtreeplus folder already exists, tell user to delete it first
fprintf('Generating mtreeplus in folder %s\n', mtreeplus_path);
if exist(mtreeplus_path, 'dir')
   disp('Folder already exists, please delete it first. Abort.')
   return
end


% find original mtree
[mtree_file, mtree_path] = find_mtree();


% query to proceed
answer = input('Proceed [y/n] ?', 's');
if ~length(answer)==1 || ~strcmpi(answer, 'y')
   disp('Abort.')
   return
end



% copy contents of mtree path to mtreeplus path
copyMtreeFiles(mtree_path, mtreeplus_path)



% generate/patch mtreeplus
generate_mtreeplus(mtree_file, mtreeplus_file)



% finito
fprintf('\nApparent success.\n');
flag = true;
return




% =================== HELPERS and WORKERS ===========================


function [mtree_file, mtree_path] = find_mtree()
   % find matlab's original mtree
   
   % multiple candidates?
   mtree_candidates = which(MTREE_FILENAME, '-all');
   
   % if multiple candidates, ask user to choose, otherwise use the identified candidate
   choice = NaN;
   if length(mtree_candidates)==1
      choice = 1;
   else
      fprintf('Multiple %s candidates found. Which to use? (Press Ctrl-C to abort):\n', MTREE_STRING)
      for k = 1:length(mtree_candidates)
         fprintf('[%d] %s\n', k, mtree_candidates{k});
      end
      while isnan(choice)
         choice_string = input('Number: ', 's');
         try % try converting to a valid number
            choice = sscanf(choice_string, '%d');
            if ~isnumeric(choice) || (choice<=0) || (choice > length(mtree_candidates))
               error('Invalid choice: %s\n', choice_string);
            end
         catch
            fprintf('Invalid choice: %s\n', choice_string);
            choice = NaN;
         end
      end
   end
   mtree_file = mtree_candidates{choice};
   fprintf('Using %s in %s\n', MTREE_STRING, mtree_file)
   
   % extract mtree path
   [mtree_path,~,~] = fileparts(mtree_file);

end

% ========================================================================================


function generate_mtreeplus(mtree_file, mtreeplus_file)
   % copy and patch mtree into mtreeplus
   
   % open files
   fprintf('Creating and patching mtreeplus...\n')
   fid_mtree     = fopen(mtree_file    , 'r');
   fid_mtreeplus = fopen(mtreeplus_file, 'w');
   
   % copy and patch mtreeplus file
   try
      copyAndPatchMTREEPLUS(fid_mtree, fid_mtreeplus);  % dispatcher
   catch ME
      disp('An error occured during patching:')
      disp(ME)
      disp('Closing files and rethrowing error.')
      fclose(fid_mtree);
      fclose(fid_mtreeplus);
      rethrow(ME)
   end
   
   % close files
   fclose(fid_mtree);
   fclose(fid_mtreeplus);
end

% ========================================================================================

function copyMtreeFiles(source, destination)
   % copy contents of mtree path to mtreeplus path
   % we cannot use copyfile as is (tries to) preserve file permissions and ownership,
   % so we invoke system copy commands to own the copies
   fprintf('Copying files...\n')
   if ispc()
      copy_command = sprintf('xcopy /s "%s\\*.*" "%s"', source, destination);  % WINDOWS
   elseif ismac()
      copy_command = sprintf('cp -R ''%s'' ''%s'''  , source, destination);  % MAC
   elseif isunix()
      copy_command = sprintf('cp -R ''%s'' ''%s'''  , source, destination);  % LINUX
   else
      error('Platform not supported.')
   end
   fprintf('... invoking:  %s\n', copy_command);
   errorlevel = system(copy_command,'-echo');
   if (errorlevel==0)
      fprintf('... copying successful.\n');
   else
      fprintf('... copying failed.\n');
      error('MTREE generation failed.');
   end
end

% ========================================================================================

function lineending = getNewlineForPlatform()
   if     ispc()  , lineending = '\r\n';  % Windows
   elseif isunix(), lineending = '\n';    % Linux/Unix
   elseif ismac() , lineending = '\n';    % Mac
   else           , lineending = '\n';    % other
   end
end

% ========================================================================================

function copyAndPatchMTREEPLUS(fid_src, fid_dest)
   % choose patch helper depending on matlab version
   % MATLAB 9.0  R2016a  35
   % MATLAB 9.1  R2016b  36
   % MATLAB 9.2  R2017a  37
   % MATLAB 9.3  R2017b  38
   % MATLAB 9.4  R2018a  39
   % MATLAB 9.5  R2018b  40
   % MATLAB 9.6  R2019a  41
   % MATLAB 9.7  R2019b  42
   % MATLAB 9.8  R2020a  43
   % MATLAB 9.9  R2020b  44
   % MATLAB 9.10 R2021a  45
   % MATLAB 9.11 R2021b  --
   TESTED = true; UNTESTED = false;
   if     verLessThan('MATLAB', '9.0')
      error('Incompatible Matlab version.');
   elseif verLessThan('MATLAB', '9.1'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.0  --> 2016a
   elseif verLessThan('MATLAB', '9.2'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.1  --> 2016b
   elseif verLessThan('MATLAB', '9.3'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.2  --> 2017a
   elseif verLessThan('MATLAB', '9.4'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.3  --> 2017b
   elseif verLessThan('MATLAB', '9.5'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.4  --> 2018a
   elseif verLessThan('MATLAB', '9.6'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.5  --> 2018b
   elseif verLessThan('MATLAB', '9.7'),  copyAndPatch__generic(fid_src, fid_dest, TESTED);     % Version 9.6  --> 2019a
   elseif verLessThan('MATLAB', '9.8'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.7  --> 2019b
   elseif verLessThan('MATLAB', '9.9'),  copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.8  --> 2020a
   elseif verLessThan('MATLAB', '9.10'), copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.9  --> 2020b
   elseif verLessThan('MATLAB', '9.11'), copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.10 --> 2021a
   elseif verLessThan('MATLAB', '9.12'), copyAndPatch__generic(fid_src, fid_dest, UNTESTED);   % Version 9.11 --> 2021b
   else
      copyAndPatch__unknown(fid_src, fid_dest, UNTESTED);
   end
end

% ========================================================================================

function copyAndPatch__unknown(fid_src, fid_dest, UNTESTED)
   disp('Unknown MATLAB version >9.9, trying generic method.')
   copyAndPatch__generic(fid_src, fid_dest, UNTESTED);
end

% ========================================================================================

function copyAndPatch__generic(fid_mtree, fid_mtreeplus, tested)
   disp('Using generic patcher. Numbers indicate line numbers.');
   if tested
      disp('Info: Compatible Matlab version detected.');
   else
      warning('Patcher not tested with this version of Matlab! Proceeding with fingers crossed...');
   end
   % adjustments to me made, in this order!
   % 1) Adjust class name:            classdef mtree   ==>  classdef mtreeplus
   % 2) Adjust first accessors:       properties ...   ==>  properties
   % 3) Adjust constructor:           function o = mtree( text, varargin ) ==> ...mtreeplus...
   lineending = getNewlineForPlatform();
   % walk through the file, row by row, modify where necessary
   row_index = 0;
   search_index = 1;
   while ~feof(fid_mtree)
      row_index   = row_index + 1;     % increase row counter
      fprintf('%d ', row_index);       % output current line for debug purposes
      row_content = fgetl(fid_mtree);  % read line
      switch search_index
         case 1
            if strncmp(strtrim(row_content), 'classdef', 8)            %  8 = length of search word
               fprintf('\nPatching line %d: classdef\n', row_index);
               row_content = strrep(row_content, MTREE_STRING, MTREEPLUS_STRING);
               search_index = 2;
            end
         case 2
            if strncmp(strtrim(row_content), 'properties', 10)         % 10 = length of search word
               fprintf('\nPatching line %d: properties accessors\n', row_index);
               row_content = '    properties';                         % four spaces to keep original indentation
               search_index = 3;
            end
         case 3
            if strncmp(strtrim(row_content), 'function o = mtree', 18) % 18 = length of search word
               fprintf('\nPatching line %d: constructor\n', row_index);
               row_content = strrep(row_content, MTREE_STRING, MTREEPLUS_STRING);
               search_index = 4;
            end
      end
      fprintf(fid_mtreeplus, '%s', row_content);  % write the line
      fprintf(fid_mtreeplus, lineending);         % write CRLF or LF
   end
   fprintf('\nFinished patching.\n');
end

% ========================================================================================


% end of outer function make_mtreeplus
end

