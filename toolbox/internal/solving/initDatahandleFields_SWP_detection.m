function SWP_detection = initDatahandleFields_SWP_detection(tspan, initialvalues, parameters)
% Fields for determining exact values of switching points
    SWP_detection.switchingpoints = {};
    SWP_detection.switchingIndices = {};
    SWP_detection.switchingFunction = {};
    SWP_detection.jumpFunction = {};

    SWP_detection.tspan = tspan; 
    SWP_detection.initialvalues = initialvalues; 
    SWP_detection.parameters = parameters; 

    SWP_detection.t1 = tspan(1);
    SWP_detection.t2 = [];
    SWP_detection.t3 = [];

    SWP_detection.switch_cond_t1 = [];
    SWP_detection.switch_cond_t2 = [];
    SWP_detection.switch_cond_t3 = [];

    SWP_detection.ctrlif_index_t1 = [];
    SWP_detection.ctrlif_index_t2 = [];
    SWP_detection.ctrlif_index_t3 = [];

    SWP_detection.function_index_t1 = [];
    SWP_detection.function_index_t2 = [];
    SWP_detection.function_index_t3 = [];
    
    SWP_detection.signature = {};
    SWP_detection.signature.function_index = {};
    SWP_detection.signature.ctrlif_index = {};
    SWP_detection.signature.switch_cond = {};

    SWP_detection.solution_until_t1 = {};
    SWP_detection.solution_until_t2 = {};
    SWP_detection.solution_until_t3 = {};

    SWP_detection.uniqueSwEnumeration = 0;
end