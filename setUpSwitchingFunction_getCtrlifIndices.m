function switchingFcn = setUpSwitchingFunction_getCtrlifIndices(switchingFcn)



% when the ctrlif index is set, (in the ctrlif)
% find out in which order which ctrlif (with its corresponding index
% occurs in the function
% One gets a 1on1 comparable vector, that can be used to interpret the
% indexes of rIndex.BODY.ctrlif.
cIndex = mtree_cIndex();
config = makeConfig();
% the ctrlif index is hard coded inside the ctrlif function call, placed as
% argument for in the ctrlif
% i.e. search for all strings of arg 4 and save the index w.r.t to
% mtreeobj.C in i
% temp_value = mtreeobj.C(mtreeobj.T(index.BODY.ctrlif_Arg(:,4), cIndex.stringTableIndex));
% out = zeros(1,length(temp_value));
% for j = 1:length(temp_value)
%     out(j) = str2double(temp_value{j});
% end
l = size(switchingFcn.mtreeobj, 2);

for i = 1:l
    rIndex = struct('HEAD', struct(), 'BODY', struct());
    rIndex.BODY = mtree_rIndex_function(switchingFcn.mtreeobj{3,i}, rIndex.BODY, config.ctrlif.functionName);
    if ~isfield(rIndex.BODY, config.ctrlif.functionName)
        switchingFcn.mtreeobj{6, i} = [];
        switchingFcn.mtreeobj{7, i} = [];
        continue
    end
    switchingFcn.mtreeobj{6, i} = str2double(switchingFcn.mtreeobj{3, i}.C(switchingFcn.mtreeobj{3, i}.T(rIndex.BODY.ctrlif_Arg(:,4), cIndex.stringTableIndex)))';
    switchingFcn.mtreeobj{7, i} = rIndex.BODY;
end













end
