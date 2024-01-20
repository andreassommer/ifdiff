%%






%% Test

integrator = @ode45;
t0 = 0;
tf = 20;
timeinterval = [t0,tf];
initstates   = [1  0 ];
p            = 5.437;

fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-12);
filename = 'test_preprocess_performance';
tic
hdlrhs_test = prepareDatahandleForIntegration(filename, 'solver', func2str(integrator), 'options', odeoptions);
toc


%%
% mt = mtree('test_fun_3.m', '-file', '-comments');
% mt.dumptree()
% mt = mtree('preprocessed_test_fun_3.m', '-file', '-comments');
% mt.dumptree()