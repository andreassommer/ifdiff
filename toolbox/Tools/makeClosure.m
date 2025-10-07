function handle = makeClosure(inputData)
   % handle = makeClosure()
   % handle = makeClosure(inputData)
   % 
   % Creates a closure.
   %
   % INPUT:   [none] --> creates a closure about empty data
   %       inputData --> creates a closure initialized with given data
   %
   % OUTPUT:  handle with .getData() and .setData() methods
   %          (i.e. a struct with fields .getData and .setData)
   %
   % Usage:  Use makeClosure to create a handle (a reference) on data.
   %         Note that the original data, if specified, is unmodified!
   %         Pass the handle to every function that shall modify the data.
   %         Inside these functions, get the data by calling the .getData() method
   %         and, before exit, set it back by calling the .setData() method.
   %
   % Example:
   %    function testClosure()
   %       data.content = 'original content';    % create original content
   %       handle = makeClosure(data);           % make a closure initialized with data
   %       disp(handle.getData());               % show the content of the closure
   %       modify(handle);                       % modify the closure
   %       disp(handle.getData());               % show the content of the closure
   %       disp(data)                            % the original data stays unmodified!
   %       modify(handle);                       % modify the closure
   %       disp(handle.getData());               % show the content of the closure
   %     end
   %
   %   function modify(handle)
   %      data = handle.getData();
   %      data.content = [data.content ' is modified'];
   %      handle.setData(data);
   %   end
   %
   %
   % Author: Andreas Sommer, Feb2017
   % andreas.sommer@iwr.uni-heidelberg.de
   % email@andreas-sommer.eu
   %
   persistent data
   
   % If some initial input is given, use it
   if nargin==0
      data = [];
   else
      data = inputData;
   end
   
   % create the handle with getter & setter method
   handle = struct('getData',@getData,'setData',@setData);
   
   % finito
   return
   
   % =============

   % getter method
   function outData = getData()
      outData = data;
   end

   % setter method
   function setData(inData)
      data = inData;
   end

end
