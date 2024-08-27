% new York city integration
timeinterval = [0.0, 5.0];
initstates = [1.0, 0.0];
initp = [3.0];
odeoptions = odeset( 'AbsTol', 1e-06, 'RelTol', 1e-04);   

tic
hdlsens = prepareDatahandleForIntegration('sensExample', 'integrator', 'ode23', 'options', odeoptions);
preptime = toc

tic
[sol, data] = solveODE(hdlsens, timeinterval, initstates, initp);
inttime = toc

swpoints = data.variable.switchingpoints;


% plotten
tt = timeinterval(1):0.1:timeinterval(2);

yy = deval(sol, tt);

% prepare output figure
figure(011); clf; hold on;
set(gca, 'FontSize', 16);

plot(tt, yy(1,:),  '-' , 'LineWidth', 3, 'color', [0.6,0.6,0.6]);
for i = 1:1
    plot([swpoints{i}, swpoints{i}], [0.0, 20.0], '--', 'LineWidth', 2, 'color', 'red');
end

figure(012); clf;hold on;
set(gca, 'FontSize', 16);
plot(tt, yy(2,:),  '-' , 'LineWidth', 3, 'color', [0.6,0.6,0.6]);
for i = 1:1
    plot([swpoints{i}, swpoints{i}], [0.0, 20.0], '--', 'LineWidth', 2, 'color', 'red');
end


% sensitivity with END (without SWP detection)
h = 1e-03;
diststates = ones(2,1) * initstates + h*eye(2);

[tbadend0, xbadend0] = ode23(@(t,x) sensExample(t,x,initp), timeinterval, initstates, odeoptions);
[tbadend1, xbadend1] = ode23(@(t,x) sensExample(t,x,initp), timeinterval, diststates(1,:), odeoptions);
[tbadend2, xbadend2] = ode23(@(t,x) sensExample(t,x,initp), timeinterval, diststates(2,:), odeoptions);

sensmat0 = [(xbadend1(end,:)-xbadend0(end,:))' (xbadend2(end,:)-xbadend0(end,:))'] * 1.0/h

% sensitivity with END (with SWP detection)
[sol1, data1] = solveODE(hdlsens, timeinterval, diststates(1,:), initp);
[sol2, data2] = solveODE(hdlsens, timeinterval, diststates(2,:), initp);

sensmat1 = [(sol1.y(:,end)-sol.y(:,end))/h (sol2.y(:,end)-sol.y(:,end))/h]

%% sensitivity with IND
newdata.variable.active_spd = 0;
newdata.variable.getCondition = 0;
newdata.variable.useFixSignatureWhenExtendingODE = 0; 
newdata.variable.initialised = 1;
newdata.variable.controloperators = 0;
newdata.variable.signaturearray = {[0]};
newdata.variable.currentsignature = {[NaN]};
newdatahandle = makeClosure(newdata);

sensirhs = @(t,x) rhsIND(t,x,initp,newdatahandle,sol);
sensiinit = [1;0;0;1];
tsw = swpoints{1};
tspan1 = [0, tsw];
tspan2 = [tsw, 5.0];

[t1, g1] = ode23(sensirhs, tspan1, sensiinit, odeoptions);

hcplx = 1.0e-20;
ysw = deval(sol, tsw);

dsigmadt = imag(data.constant.switchingfunctionhandles{1}(tsw+hcplx*1i,ysw, initp))/hcplx;
dsigmadx1 = imag(data.constant.switchingfunctionhandles{1}(tsw,ysw+[hcplx;0]*1i, initp))/hcplx;
dsigmadx2 = imag(data.constant.switchingfunctionhandles{1}(tsw,ysw+[0;hcplx]*1i, initp))/hcplx;
dsigmadx = [dsigmadx1, dsigmadx2];

fminus = preprocessedRhs(tsw, ysw, initp,newdatahandle);

newdata = newdatahandle.getData();
newdata.variable.signaturearray{1} = [1];
newdatahandle.setData(newdata);

fplus = preprocessedRhs(tsw, ysw, initp,newdatahandle);

totaldsigmadt = dsigmadt + dsigmadx * fminus;

upmat = eye(2) + ((fplus-fminus) * dsigmadx) * 1.0/totaldsigmadt;

[t2, g2] = ode23(sensirhs, tspan2, sensiinit, odeoptions);

sensmat2 = reshape(g2(end,:),2,2) * upmat * reshape(g1(end,:),2,2)
