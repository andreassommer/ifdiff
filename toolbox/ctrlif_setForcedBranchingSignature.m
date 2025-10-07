function ctrlif_setForcedBranchingSignature(datahandle, t, y) 
% initilize forced branching 

data = datahandle.getData();
config = makeConfig();

[A,B,C] = ctrlif_getSignature(datahandle,t,y);

% forced branching signature
data.forcedBranching.switch_cond_forcedBranching     = A; 
data.forcedBranching.ctrlif_index_forcedBranching   = B; 
data.forcedBranching.function_index_forcedBranching = C; 

% preallocate arrays to store current signature as it would be without forced branching
data.forcedBranching.switch_cond     = zeros(1,length(data.forcedBranching.switch_cond_forcedBranching));
data.forcedBranching.ctrlif_index   = zeros(1,length(data.forcedBranching.ctrlif_index_forcedBranching));
data.forcedBranching.function_index = cell(length(data.forcedBranching.function_index_forcedBranching),1);

% counter from the ctrlif
data.forcedBranching.ctrlifCounter = 0;
data.caseCtrlif = config.caseCtrlif.forcedBranching; % case forced branching

datahandle.setData(data);


end


