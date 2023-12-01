function y = ctrlif(condition, truepart, falsepart, ctrlif_index, function_index, datahandle)
   % function for:
   %
   % - supervising signature during integration (.active_SWP_detection = 1)
   % - forced evaluation condition during extending of the ODE solution object until switch
   % - receiving the siganture at any timepoint t (.getSignature = 1)
   % - forced evaluation with a given sigature for sensitivity calculation
   %
   % by the ctrilf one gets the condition, ctrlif_index, function_index
   % those vectors are preallocated using .ctrlifCounter

   data = datahandle.getData();

   switch data.caseCtrlif
      case 0 % default
         if condition
            y = truepart;
         else
            y = falsepart;
         end
         
      case 1 % forcedBranching
         % active_SWP_detection: during integration used in extendODE, solveODE
         % forced branching method: always return the initial true/false value
         
         data.forcedBranching.ctrlifCounter = data.forcedBranching.ctrlifCounter + 1;
         
         data.forcedBranching.switch_cond(data.forcedBranching.ctrlifCounter)     = condition;
         data.forcedBranching.ctrlif_index(data.forcedBranching.ctrlifCounter)   = ctrlif_index;
         data.forcedBranching.function_index{data.forcedBranching.ctrlifCounter} = function_index;
         
         
         forced_evaluation_cond = data.forcedBranching.switch_cond_forcedBranching(data.forcedBranching.ctrlifCounter);
         
         if forced_evaluation_cond
            y = truepart;
         else
            y = falsepart;
         end
         
         % ctrlifCounter for preallocation of signature
         
         if length(data.forcedBranching.switch_cond_forcedBranching) == data.forcedBranching.ctrlifCounter
            data.forcedBranching.ctrlifCounter = 0;
         end
         
      case 2 % extendODE_until switch
         
         data.forcedBranching.ctrlifCounter = data.forcedBranching.ctrlifCounter + 1;
         
         forced_evaluation_cond = data.forcedBranching.switch_cond_forcedBranching(data.forcedBranching.ctrlifCounter);
         
         if forced_evaluation_cond
            y = truepart;
         else
            y = falsepart;
         end
         
         % ctrlifCounter for preallocation of signature
         
         if length(data.forcedBranching.switch_cond_forcedBranching) == data.forcedBranching.ctrlifCounter
            data.forcedBranching.ctrlifCounter = 0;
         end
         
       case 3 % ctrlif_getSignature
         data.getSignature.ctrlifCounter = data.getSignature.ctrlifCounter + 1;

         data.getSignature.switch_cond    = ctrlif_getSignaturePreallocation(condition,      data.getSignature.switch_cond,    data.getSignature.ctrlifCounter, 1);
         data.getSignature.ctrlif_index   = ctrlif_getSignaturePreallocation(ctrlif_index,   data.getSignature.ctrlif_index,   data.getSignature.ctrlifCounter, 1);
         data.getSignature.function_index = ctrlif_getSignaturePreallocation(function_index, data.getSignature.function_index, data.getSignature.ctrlifCounter, 2);

         if condition
            y = truepart;
         else
            y = falsepart;
         end
         
      case 4 % sensitivity calculation
         
         % evaluate RHS with a given signature for calculating the sensitivities
         
         modelStage = data.computeSensitivity.modelStage;
         
         data.computeSensitivity.ctrlifCounter = data.computeSensitivity.ctrlifCounter + 1;
         signature = data.SWP_detection.signature.switch_cond{modelStage};
         forced_evaluation_cond = signature(data.computeSensitivity.ctrlifCounter);
         
         if forced_evaluation_cond
            y = truepart;
         else
            y = falsepart;
         end
         
         % ctrlifCounter for preallocation of signature
         if length(signature) == data.computeSensitivity.ctrlifCounter
            data.computeSensitivity.ctrlifCounter = 0;
         end
         
   end
   
   datahandle.setData(data);
end


