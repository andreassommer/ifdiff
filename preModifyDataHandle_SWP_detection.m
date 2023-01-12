function SWP_detection = preModifyDataHandle_SWP_detection(tspan, initialvalues, parameters)



SWP_detection.switchingpoints = {};
SWP_detection.switchingindices = {};
SWP_detection.switchingFunction = {};

SWP_detection.tspan = tspan; 
SWP_detection.initialvalues = initialvalues; 
SWP_detection.parameters = parameters; 



% initilize .SWP_detection fields
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