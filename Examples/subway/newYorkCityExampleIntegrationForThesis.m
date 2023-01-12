% new York city integration

integrator = @ode45;

timeinterval = [0.0, 65.0];
initstates = [0.0, 0.0, 0.0].';
odeoptionssubwaymodel = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-10);
%%

tic
hdlnyc = prepareDatahandleForIntegration('newYorkCitySubwayModelRhs', ...
    'solver', func2str(integrator), 'options', odeoptionssubwaymodel);
toc

%%
tic
% [solnyc, datanyc] = solveODE(hdlnyc, ...
%     timeinterval, initstates, nysscc_getPhysicsParameters()); %von Tobias ->habe ich geändert

solnyc = solveODE(hdlnyc, ...
    timeinterval, initstates, nysscc_getPhysicsParameters());

toc

sol = ode45(@(t,x) newYorkCitySubwayModelRhs(t,x, nysscc_getPhysicsParameters()),timeinterval, initstates,odeoptionssubwaymodel);

%% 
hold on 
plot(sol.x, sol.y,'o')
plot(solnyc.x, solnyc.y)
hold off


%% 

%swpoints = datanyc.SWP_detection.switchingpoints; von Tobias
swpoints = solnyc.switches;
% plotten

tt = timeinterval(1):0.1:timeinterval(2);

yy = deval(solnyc, tt);

width = 6;     % Width in inches
height = 4;    % Height in inches

figure(011); clf; hold on;
pos = get(gcf, 'Position');
set(gca, 'FontSize', 16);

plot(tt, yy(1,:),  '-' , 'LineWidth', 3, 'color', [0.6,0.6,0.6]);
for i = 1:7
    plot([swpoints(i), swpoints(i)], [0.0, 2500.0], '--', 'MarkerSize',2, 'color', 'red');
end
xlabel('time [t]')
ylabel('distance [ft]')
%%
% % Here we preserve the size of the image when we save it.
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
%
% % Save the file as PNG
% print('position','-dpng','-r300');
%
%
figure(012); clf;hold on;
pos = get(gcf, 'Position');
set(gca, 'FontSize', 16);

plot(tt, yy(2,:),  '-' , 'LineWidth', 3, 'color', [0.6,0.6,0.6]);
for i = 1:7
    plot([swpoints(i), swpoints(i)], [0.0, 40.0], '--', 'MarkerSize', 2, 'color', 'red');
end
xlabel('time [t]')
ylabel('speed [ft/s]')
%
% % Here we preserve the size of the image when we save it.
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
%
% % Save the file as PNG
% print('speed','-dpng','-r300');
%

figure(013); clf; hold on;
pos = get(gcf, 'Position');
set(gca, 'FontSize', 16);

plot(tt, yy(3,:),  '-' , 'LineWidth', 3, 'color', [0.6,0.6,0.6]);
for i = 1:7
    plot([swpoints(i), swpoints(i)], [0.0, 4500.0], '--','MarkerSize',2, 'color', 'red');
end
xlabel('time [t]')
ylabel('energy [Wh]')
% % Here we preserve the size of the image when we save it.
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
%
% %% Save the file as PNG
% % print('energy','-dpng','-r300');
%
% % sensitivity with END (without SWP detection)
% h = 1e-06;
% diststates = initstates * ones(1,3) + h*eye(3);
% params = nysscc_getPhysicsParameters();
%
% %%%timeinterval = [timeinterval(1) swpoints{1}+1e-3];
% tic
% [tbadend0, xbadend0] = integrator(@(t,x) newYorkCitySubwayModelRhs(t,x,params), timeinterval, initstates, odeoptionssubwaymodel);
% [tbadend1, xbadend1] = integrator(@(t,x) newYorkCitySubwayModelRhs(t,x,params), timeinterval, diststates(1,:), odeoptionssubwaymodel);
% [tbadend2, xbadend2] = integrator(@(t,x) newYorkCitySubwayModelRhs(t,x,params), timeinterval, diststates(2,:), odeoptionssubwaymodel);
% [tbadend3, xbadend3] = integrator(@(t,x) newYorkCitySubwayModelRhs(t,x,params), timeinterval, diststates(3,:), odeoptionssubwaymodel);
% toc
%
% sensmatFDNaive = [(xbadend1(end,:)-xbadend0(end,:))' (xbadend2(end,:)-xbadend0(end,:))' (xbadend3(end,:)-xbadend0(end,:))'] * 1.0/h;
%
% % sensitivity with END (with SWP detection)
% tempdata = hdlnyc.getData();
% tempdata.variable.getsignature     = false;
% tempdata.variable.controloperators = false;
% hdlnyc.setData(tempdata);
%
% [sol0, data0] = solveODE(hdlnyc, timeinterval, initstates, params);
% tic
% [sol1, data1] = solveODE(hdlnyc, timeinterval, diststates(1,:), params);
% [sol2, data2] = solveODE(hdlnyc, timeinterval, diststates(2,:), params);
% [sol3, data3] = solveODE(hdlnyc, timeinterval, diststates(3,:), params);
% toc
% sensmatFDSwitch = [(sol1.y(:,end)-sol0.y(:,end)) (sol2.y(:,end)-sol0.y(:,end)) (sol3.y(:,end)-sol0.y(:,end))]*1.0/h;
%
% % sensitivity with IND
% odeoptionssubwaymodel = odeset( 'AbsTol', 1e-14,...
%                                 'RelTol', 1e-08);
%
%
% newdata.variable.getsignature     = false;
% newdata.variable.initialised      = true;
% newdata.variable.controloperators = false;
% newdata.variable.signaturearray   = {datanyc.variable.signaturearray{1}};
% newdata.variable.currentsignature = {datanyc.variable.currentsignature{1}};
% newdata.constant.ctrlifcount      = datanyc.constant.ctrlifcount;
% newdatahandle = makeClosure(newdata);
%
% sensmatIND = eye(3);
%
% sensirhs = @(t,x) rhsIND(t,x,params,newdatahandle,solnyc);
% sensiinit = reshape(sensmatIND,9,1);
% swindices = datanyc.variable.switchingindices;
% swfuncs = datanyc.constant.switchingfunctionhandles;
% numswitches = length(datanyc.variable.switchingpoints);
% hcplx = 1.0e-20;
%
% tic
% for ii=1:numswitches
%     tsw = swpoints{ii};
%     if ii == 1
%         tspantemp = [timeinterval(1), tsw];
%     else
%         tspantemp = [swpoints{ii-1}, tsw];
%     end
%
%     sol = integrator(sensirhs, tspantemp, sensiinit, odeoptionssubwaymodel);
%
%     ysw = deval(solnyc, tsw);
%
%     dsigmadt = imag(swfuncs{swindices{ii}}(tsw+hcplx*1i,ysw, params))/hcplx;
%     dsigmadx1 = imag(swfuncs{swindices{ii}}(tsw,ysw+[hcplx;0;0]*1i, params))/hcplx;
%     dsigmadx2 = imag(swfuncs{swindices{ii}}(tsw,ysw+[0;hcplx;0]*1i, params))/hcplx;
%     dsigmadx3 = imag(swfuncs{swindices{ii}}(tsw,ysw+[0;0;hcplx]*1i, params))/hcplx;
%     dsigmadx = [dsigmadx1, dsigmadx2, dsigmadx3];
%
%     fminus = preprocessedRhs(tsw, ysw, params, newdatahandle);
%
%     newdata = newdatahandle.getData();
%     newdata.variable.signaturearray{1} = datanyc.variable.signaturearray{ii+1};
%     newdatahandle.setData(newdata);
%
%     fplus = preprocessedRhs(tsw, ysw, params, newdatahandle);
%
%     totaldsigmadt = dsigmadt + dsigmadx * fminus;
%
%     upmat = eye(3) + ((fplus-fminus) * dsigmadx) * 1.0/totaldsigmadt;
%
%     sensmatIND = upmat * reshape(deval(sol,tspantemp(2)), 3, 3) * sensmatIND;
% end
%
% tspantemp = [swpoints{end}, timeinterval(2)];
% sol = integrator(sensirhs, tspantemp, sensiinit, odeoptionssubwaymodel);
% sensmatIND = reshape(deval(sol,timeinterval(2)), 3, 3) * sensmatIND;
% toc
%
% sensmatFDNaive
% sensmatFDSwitch
% sensmatIND
% valinit = [0.0, 1.0, 0.0].';
% [solval, dataval] = solveODE(hdlnyc, timeinterval, valinit , params);
%
% solval.y(:,end)
% (solnyc.y(:,end) + sensmatIND*valinit)
% (solnyc.y(:,end) + sensmatFDNaive*valinit)
% (solnyc.y(:,end) + sensmatFDSwitch*valinit)



