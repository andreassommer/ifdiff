function new_name = preprocess_setUpNewFcnName(name)
config = makeConfig(); 

new_name = [config.preprocess.prefix_new_fcn_call, name]; 

end 