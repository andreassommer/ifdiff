odeOpts = odeset('AbsTol', 1e-10, 'RelTol', 1e-05);
p = [];


%%
% preprocessing:
clc
tic
hdlCoffein11 = prepareDatahandleForIntegration('ODERHSFunctionCoffeinWithP', 'options', odeOpts, 'solver', 'ode23');
toc

%%
% ode23
tic 
[solCoffein11, dtCoffein11] = solveODE(hdlCoffein11, [0, 10], ODEInitialValuesCoffein(), []);
toc

