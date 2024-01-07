%%

m = mtree('rhs_test.m', '-file', '-comments');
%m.dumptree()
c = strings(m);
a = m.mtfind('String', '% IFDIFF:ignore');
b = Parent(a);
index = b.indices();
z = mtree_findNode(m, 'Kind', 'comment');

m.strings()






%% Test

integrator = @ode45;
t0 = 0;
tf = 20;
timeinterval = [t0,tf];
initstates   = [1  0 ];
p            = 5.437;

fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-12);
filename = 'canonicalExampleRHS';
tic
hdlrhs_test = prepareDatahandleForIntegration(filename, 'solver', func2str(integrator), 'options', odeoptions);
toc

 