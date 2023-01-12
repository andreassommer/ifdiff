function preprocessed = preprocess_fcnInRhs(preprocessed)
% preprocess functions that are called in the rhs (first functions;
% filename)
% preprocess them (adapt all fcn calls & set ctrlif % set ctrlif and function index)
%
%

if isempty(preprocessed.fcn)
    % nothing to do
    return
end


% replace abs, min, max, iif etc. by ctrlif
% add preprocessed_ to function name and add datahandle/function_handle as input variable

l = size(preprocessed.fcn, 2);
fcn = preprocessed.fcn;
fcn2 = preprocessed.fcn;

fcn_with_switch = zeros(1,l);

for i = 1:l
    
    mtree_fcn = mtreeplus([preprocessed.fcn{1,i}, '.m'], '-file');
    
    [mtree_fcn, ctrlif_new] = preprocess_addCtrlif(mtree_fcn, preprocessed.ctrlif_index);
    
    % check whether any ctrlif has been set, if not remove function
    if preprocessed.ctrlif_index ~= ctrlif_new
        preprocessed.ctrlif_index = ctrlif_new;
        fcn{2,i} = preprocess_setUpNewFcnName(fcn{1,i});
        [mtree_fcn, ~] = preprocess_editFunctionHead(mtree_fcn);
        fcn{3,i} = mtree_fcn;
        fcn2{1,i} = [];
        fcn_with_switch(i) = 1;
    else
        fcn2{2,i} = preprocess_setUpNewFcnName(fcn2{1,i});
        [mtree_fcn, ~] = preprocess_editFunctionHead(mtree_fcn);
        fcn2{3,i} = mtree_fcn;
        fcn{1,i} = [];
    end
end

index = 1:l;
fcn = fcn(:,index(fcn_with_switch == 1));
fcn2 = fcn2(:,index(fcn_with_switch ~= 1));

% check whether functions with no switch have other function inside which
% has a switch
for i = 1:size(fcn2,2)
    stringsOfMtree = fcn2{3,i}.C;
    for j = 1:size(fcn,2)
        for k = 1:length(stringsOfMtree)
            
            nameOfFcn = fcn{1,j};
            if strcmp(stringsOfMtree{k},nameOfFcn)
                fcn(:,end + 1) = fcn2(:,i); 
                break
            end
        end
    end
end


preprocessed.fcn = fcn;


end





