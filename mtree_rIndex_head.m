function index = mtree_rIndex_head(mtreeobj, index) 
cIndex = mtree_cIndex(); 


% Part 1: FUNCTION HEAD 


% getting all the function indices; if the mtreeobj is a function, then the
% first element of functionIndexList refers to line 1; the rest to nested
% functions. 
% functionIndexList = mtreeobj.mtfind('Kind', 'FUNCTION').indices;
functionIndexList = mtree_mtfind(mtreeobj,'Kind', mtreeobj.K.FUNCTION); 


if isempty(functionIndexList)
    % if there is no function, then the first line represents the "BODY". 
    index.BODY = 1;
    return
end

    
    
    % overall and first function node
    index.FUNCTION = functionIndexList(1);
    
%     % get all indices of the nested functions are name them according to
%     % their apperance in the mtreeobj
%     for i = 2:length(functionIndexList)
%         index.InlineFun.(['indexFun' num2str(i-1)]) = functionIndexList(i);
%     end
    

    % First ETC Node after FUNCTION node
    % Can be unterstood as "here the function head starts", thats why it is
    % called "HEAD"
    index.HEAD = mtreeobj.T(index.FUNCTION, cIndex.indexLeftchild);
    
    % Outs = Outputs
    index.Outs  = mtreeobj.T(index.HEAD,     cIndex.indexLeftchild);
    
    % Second ETC Node
    index.ETC2  = mtreeobj.T(index.HEAD,     cIndex.indexRightchild);
    
    % Line that contains the name of the function; 
    % i.e. ('id est; latin for: that means, that is to say')
    % the field cIndex.stringTableIndex contains the index, that refers to
    % the function name as a character string that is saved in mtreeobj.C 
    index.Fname = mtreeobj.T(index.ETC2,     cIndex.indexLeftchild);
    
    % Start of the function Body (first expression node, i.e. new line
    % node), that the file contains
    index.BODY  = mtreeobj.T(index.FUNCTION, cIndex.indexRightchild);

    % Ins = Inputs
    % get first argument and then loop through all nextNodes of the following
    % arguments until there so no more nextNode -> take last nextNode which is
    % then the last input variable (e.g. lstArg)
    index = mtree_rIndex_getFunctionArguments(mtreeobj, index, 'ETC2'); 
    
    
  
end 