function switchingfunctionhandle = setUpSwitchingFunction_ExportFunctions(switchingFcn) 
% export switching function as source code. 
% need to export new rhs and all the other functions
% 
% input: mtree of the functions that we want to export 
% output: function handle of the switching function 

l = size(switchingFcn.mtreeobj_switchingFcn,2); 
for i = 1:l
    name = switchingFcn.mtreeobj_switchingFcn{1,i};    
    newfile = fopen(fullfile(switchingFcn.path, [name, '.m']), 'w');
    fprintf(newfile, switchingFcn.mtreeobj_switchingFcn{3,i}.tree2str);
    fclose(newfile);
end

% generate function handle
switchingfunctionhandle = str2func(switchingFcn.mtreeobj_switchingFcn{1,1}); 

end

