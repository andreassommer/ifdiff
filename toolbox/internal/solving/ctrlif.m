function y = ctrlif(num, truepart, falsepart, ctrlif_index, function_index, datahandle)
% function for:
%
% - supervising signature during integration (.active_SWP_detection = 1)
% - forced evaluation condition during extending of the ODE solution object until switch
% - receiving the siganture at any timepoint t (.getSignature = 1)
% - forced evaluation with a given sigature for sensitivity calculation
%
% by the ctrilf one gets the condition, ctrlif_index, function_index
% those vectors are preallocated using .ctrlifCounter

config = makeConfig();
data = datahandle.getData();

condition = (num >= 0);

switch data.caseCtrlif
    case config.caseCtrlif.default
        if condition
            y = truepart;
        else
            y = falsepart;
        end

    case config.caseCtrlif.forcedBranching
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

    case config.caseCtrlif.extendODEuntilSwitch

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

    case config.caseCtrlif.getSignature
        data.getSignature.ctrlifCounter = data.getSignature.ctrlifCounter + 1;

        data.getSignature.switch_cond    = ctrlif_getSignaturePreallocation(condition,      data.getSignature.switch_cond,    data.getSignature.ctrlifCounter, 1);
        data.getSignature.ctrlif_index   = ctrlif_getSignaturePreallocation(ctrlif_index,   data.getSignature.ctrlif_index,   data.getSignature.ctrlifCounter, 1);
        data.getSignature.function_index = ctrlif_getSignaturePreallocation(function_index, data.getSignature.function_index, data.getSignature.ctrlifCounter, 2);

        if condition
            y = truepart;
        else
            y = falsepart;
        end
    case config.caseCtrlif.getSignatureChange
        data.getSignature.ctrlifCounter = data.getSignature.ctrlifCounter + 1;

        data.getSignature.switch_cond    = ctrlif_getSignaturePreallocation(condition,      data.getSignature.switch_cond,    data.getSignature.ctrlifCounter, 1);
        data.getSignature.ctrlif_index   = ctrlif_getSignaturePreallocation(ctrlif_index,   data.getSignature.ctrlif_index,   data.getSignature.ctrlifCounter, 1);
        data.getSignature.function_index = ctrlif_getSignaturePreallocation(function_index, data.getSignature.function_index, data.getSignature.ctrlifCounter, 2);

        forced_evaluation_cond = data.getSignature.switch_cond_forcedBranching(data.getSignature.ctrlifCounter);
        if forced_evaluation_cond
            y = truepart;
        else
            y = falsepart;
        end
    case config.caseCtrlif.computeSensitivities

        % evaluate RHS with a given signature for calculating the sensitivities

        modelStage = data.computeSensitivity.modelStage;

        data.computeSensitivity.ctrlifCounter = data.computeSensitivity.ctrlifCounter + 1;
        signature = data.SWP_detection.signature{modelStage};

        % Cannot evaluate model with sliding mode signature (i.e. multiple signatures).
        if ~isscalar(signature)
            throw(evaluationWithFilippovSignatureException)
        end

        forced_evaluation_cond = signature.switchCond(data.computeSensitivity.ctrlifCounter);

        if forced_evaluation_cond
            y = truepart;
        else
            y = falsepart;
        end

        % ctrlifCounter for preallocation of signature
        if length(signature.switchCond) == data.computeSensitivity.ctrlifCounter
            data.computeSensitivity.ctrlifCounter = 0;
        end
end

datahandle.setData(data);
end

%% Exceptions
function e = evaluationWithFilippovSignatureException
msg = 'Cannot evaluate model in computeSensitivity mode for Filippov signature.\n';
e = MException('IFDIFF:Ctrlif:ModelEvaluationForFilippovSignature', msg);
end
