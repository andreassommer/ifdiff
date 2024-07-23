function new_name = preprocess_setUpNewFcnName(name)
config = makeConfig(); 

new_name = [config.preprocessedFunctionNamePrefix, name];

end 