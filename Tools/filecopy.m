function [success, message] = filecopy(source, destination, useRecycler, chunksize)
% [success, message] = filecopy(source, destination, useRecycler, chunksize)
%
% Copies source to destination. Overwrites if destination if it exists.
% If the path of destination does not exist, it is created.
%
% INPUT:      source --> source file
%        destination --> target
%        useRecycler --> flag to indicate if existing destination shall be deleted or recycled  [default:  true]
%          chunksize --> amount of bytes to be copied at once                                   [default: 16384]
%
% OUTPUT:    success --> true on success, false on failure
%            message --> messages in human readable format
%
%
% NOTES:
%   1) In contrast to Matlab's copyfile(), this filecopy() does not maintain the 
%      source's permissions but uses the current user's permission for the destination file.
%   2) Wildcards * and ? are NOT SUPPORTED
%
% Andreas Sommer, Jul2025
% code@andreas-sommer.eu
%

% output variables
success = false;     %#ok<NASGU> 
message = '';

% defaults
if (nargin < 3), useRecycler =  true; end   % delete or recycle?
if (nargin < 4), chunksize   = 16384; end   % byte size for transfer

% set useRecycler to appropriate string
if (useRecycler)
   recyclestate = 'on'; 
else 
   recyclestate = 'off';
end

% check for wildcards
if contains(source, '*') || contains(source, '?') || contains(destination, '*') || contains(destination, '?')
   message = addMessage(message, 'Wildcards not yet supported');
   success = false;
   return
end

% dissect destination; if it is a folder, add the source file name
[destinationPath, destinationFile, destinationExt] = fileparts(destination);
destinationFile = strcat(destinationFile, destinationExt);  % concantenate file name and extension
if isempty(destinationFile)
   [~, sourceFile, sourceExt] = fileparts(source);
   sourceFile = strcat(sourceFile, sourceExt);
   destination = fullfile(destinationPath, sourceFile);
end

% check existence of source (note: isfile only exists from R2017b on)
if ~exist(source, 'file')
   success = false;
   message = addMessage(message, 'Source file %s does not exist', source);
   return
end

% if destination exists, delete it (move it into recycler)
if exist(destination, 'file')
   oldrecyclestate = recycle(recyclestate);
   try
      delete(destination);
      if exist(destination, 'file')
         success = false;
         message = addMessage(message, 'Could not remove existing destination file %s', destination);
         return;
      end
      if useRecycler
         message = addMessage(message, 'Moved existing destination file %s to recycle bin', destination);
      else
         message = addMessage(message, 'Deleted existing destination file %s', destination);
      end
   catch
      success = false;
      message = addMessage(message, 'Failed to delete existing destination file %s', destination);
      recycle(oldrecyclestate); % switch back to previous recycle state
      return   
   end
   recycle(oldrecyclestate); % switch back to previous recycle state
end

% ensure path to destination exists
if ~isempty(destinationPath)
   if ~exist(destinationPath, 'dir')
      [success, ~] = mkdir(destinationPath);
      if success
         message = addMessage(message, 'Created destination directory %s', destinationPath);
      else
         message = addMessage(message, 'Cannot create destination path %s', destinationPath);
         return;
      end
   end
end


% Checks done, now do the work


% try to open files - the helpers don't throw but deliver fileID -1 on failure
fIDsource      = openFile(source, 'r');
fIDdestination = openFile(destination, 'w');

% check opening
if (fIDsource      < 0), success = false; message = addMessage(message, 'Failed to open source file %s'     , source     ); return; end
if (fIDdestination < 0), success = false; message = addMessage(message, 'Failed to open destination file %s', destination); return; end

% transfer contents
[success, totalbytes] = copyContents(fIDsource, fIDdestination, chunksize);
if ~success
   message = addMessage(message, 'Error while copying file %s to %s around position %d', source, destination, totalbytes);
   closeFile(fIDsource);
   closeFile(fIDdestination);
   return;
end

% close files
[successCloseSrc , messageCloseSrc ] = closeFile(fIDsource);
[successCloseDest, messageCloseDest] = closeFile(fIDdestination);

% check closing
if ~successCloseSrc , success = false; message = addMessage(message, sprintf('Error closing source file %s : %s'     , source     , messageCloseSrc )); return; end
if ~successCloseDest, success = false; message = addMessage(message, sprintf('Error closing destination file %s : %s', destination, messageCloseDest)); return; end

% report success
success = true;
message = addMessage(message, 'OK');


end % of function




%% HELPERS

function [success, totalbytes] = copyContents(fIDsrc, fIDdest, chunksize)
   totalbytes = 0;
   try
      bytecount = 1;
      while (bytecount > 0)
         [data, bytecount] = fread(fIDsrc, chunksize);
         fwrite(fIDdest, data);
         totalbytes = totalbytes + bytecount;
      end
      success = true;
   catch
      success = false;
   end
end


function msg = addMessage(msg, fmt, varargin)
   newmsg = sprintf(fmt, varargin{:});
   if isempty(msg)
      msg = newmsg;
   else
      msg = sprintf('%s | %s', newmsg, msg);
   end
end


function [fileID, success, message] = openFile(filespec, access);
   try
      fileID = fopen(filespec, access);
   catch ME
      fileID  = -1;
      success = false;
      message = ME.message;
      return
   end
   message = '';
   success = true;
end


function [ success, message ] = closeFile(fileID)
   % invalid file id, do nothing
   if fileID < 3; 
      success = true;
      message = 'Invalid fileID';
      return;
   end
   % check if file is still open
   filename = fopen(fileID);
   if isempty(filename);
      success = true;
      message = 'File not open';
      return;
   end  
   % try to close
   try
      status = fclose(fileID);
   catch ME
      success = false;
      message = 'Error while closing file';
      return
   end
   if (status~=0)
      success = false
      message = 'Error while closing file'; 
      return
   end
   success = true;
   message = 'OK';
end