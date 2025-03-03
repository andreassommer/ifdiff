function [datahandle_minus, datahandle_plus] = slidingGetDatahandles(datahandle, ctrlif_index)
    % docs

    % generate one datahandle for either side of the switching manifold, 
    % sigma<0 and sigma>0
    datahandle_minus    = makeClosure(datahandle.getData());
    datahandle_plus     = makeClosure(datahandle.getData());

    datahandle_minus_copy = datahandle_minus.getData();
    datahandle_plus_copy  = datahandle_plus.getData();

    % set ctrlifCase to forcedBranching
    datahandle_minus_copy.ctrlifCase  = 1;
    datahandle_plus_copy.ctrlifCase   = 1;
    
    % manually set branches at the switch associated to ctrlif_index
    datahandle_minus_copy.forcedBranching.switch_cond_forcedBranching(ctrlif_index)   = 0;
    datahandle_plus_copy.forcedBranching.switch_cond_forcedBranching(ctrlif_index)    = 1;

    % write back and return
    datahandle_minus.setData(datahandle_minus_copy);
    datahandle_plus.setData(datahandle_plus_copy);

end
