initPaths();            % Initialise the paths for ifdiff
integrator = @ode45;    % Choose integrator and options
odeoptions = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

profile clear;
profile on;
datahandle = prepareDatahandleForIntegration('canonicalExampleRHS', 'integrator', func2str(integrator), 'options', odeoptions);
tspan         = [0 20];
initialvalues = [1; 0];
parameters    = 5.437;

%%%-----------------------------DIGRAPH------------------------------------
figure(1);
p = profile('info');
N = numel(p.FunctionTable);
G = digraph;
G = addnode(G,N);
nlabels = {};
for ii = 1:N
    Children = p.FunctionTable(ii).Children;
    if ~isempty(Children)
        for jj = 1:numel(Children)
            G = addedge(G,ii,Children(jj).Index);
        end
    end
end
Count = 1;
for ii=1:N
    if ~strcmp(p.FunctionTable(ii).Type,'M-function') % Keep only the functions
        G = rmnode(G,Count);
    else
        Nchars = min(length(p.FunctionTable(ii).FunctionName),10);
        nlabels{Count} = p.FunctionTable(ii).FunctionName(1:Nchars);
        Count = Count + 1;
    end
end
plot(G,'NodeLabel',nlabels,'layout','layered')
%%%------------------------------END-DIGRAPH-------------------------------

profile clear;
profile on;
sol = solveODE(datahandle, tspan, initialvalues, parameters);  % Returns a Matlab sol structure!

t = 0:0.01:20;      % Evaluation grid
y = deval(sol, t);  % Compatible to Matlab's evaluation functions

profile off;
%disp(length(t));
%disp(length(y));

%%%-----------------------------DIGRAPH------------------------------------
figure(2);
p = profile('info');
N = numel(p.FunctionTable);
G = digraph;
G = addnode(G,N);
nlabels = {};
for ii = 1:N
    Children = p.FunctionTable(ii).Children;
    if ~isempty(Children)
        for jj = 1:numel(Children)
            G = addedge(G,ii,Children(jj).Index);
        end
    end
end
Count = 1;
for ii=1:N
    if ~strcmp(p.FunctionTable(ii).Type,'M-function') % Keep only the functions
        G = rmnode(G,Count);
    else
        Nchars = min(length(p.FunctionTable(ii).FunctionName),10);
        nlabels{Count} = p.FunctionTable(ii).FunctionName(1:Nchars);
        Count = Count + 1;
    end
end
plot(G,'NodeLabel',nlabels,'layout','layered')
%%%------------------------------END-DIGRAPH-------------------------------