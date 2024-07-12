function mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj,call_node, unique_char_string)
% A call node is a node that somehow introcudes a new function call (not in general, but here!)
% call: leftchild: function_name
% rightchild: first argument etc. (see .rawdump/dumptree of a mtree) 
% 
% extract function into new line
% nothing is done when the parent node of index is of type 'EQUAL', i.e. the
% function call is already in the required form
% 
% INPUT: call_node: call node of function extract
% unique_char_string: name of new temp variable
% 
% OUTPUT: mtreeobj with new line and new function call
% 
% example: 
% 
% index: call node of max
% unique_char_string: 'new_max_call'
% 
% a = max(a,b)*c*min(b,c); 
% 
% is changed to 
% 
% new_max_call = max(a,b); 
% a = new_max_call*c*min(b,c); 
% 
% 


cIndex = mtree_cIndex();
config = makeConfig();


for i = 1:length(call_node)
    % check if node before call node is equal node
    is_that_an_equal_node = mtreeobj.T(call_node(i), cIndex.indexParentNode);
    % when the parent node of max is a equal node, then the function
    % call is already of the for 'a = max(a,b);' i.e. no transformation
    % necessary
    if (mtreeobj.T(is_that_an_equal_node, cIndex.kindOfNode) == mtreeobj.K.EQUALS)
        continue
    end
    
    name_of_new_variable = [unique_char_string, config.newLineFunctionCallOutputNameInfix, num2str(i)];
    
    [mtreeobj, ~] = mtree_extractArgIntoNewLineAbove(mtreeobj,call_node(i), name_of_new_variable); 
end



end