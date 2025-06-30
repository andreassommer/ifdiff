integrator = @ode45;
initstates   = [1];
p            = 0;

doIfdiff = true;
doSensitivities = true;
doMatlab = false;

if doIfdiff
    t0 = 0;
    tf = 1;
    timeinterval = [t0,tf];

    fprintf('Preprocessing...\n  ');
    odeoptions = odeset( 'AbsTol', 1e-14, 'MaxStep', 2);
    filename = 'sign_inconsistent_rhs';
    datahandle = prepareDatahandleForIntegration(filename, ...
        'integrator', func2str(integrator), 'options', odeoptions);
    
    fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
    tic
    sol_rhs_test = solveODE(datahandle, timeinterval, initstates, p);

    sw_points   = cell2mat(datahandle.getData().SWP_detection.switchingpoints);
    sw_points_y = deval(sol_rhs_test, sw_points);
end

if doSensitivities
    dim_y = size(sol_rhs_test.y, 1);
    dim_p = length(p);
    FDstep = generateFDstep(dim_y, dim_p, 'hy_rel_flag', true,'hp_rel_flag', true, 'hy_min', 1e-9, 'hp_min', 1e-6);
    sensFunction_ENDpiece = generateSensitivityFunction(datahandle, ...
        sol_rhs_test, FDstep, 'method', 'END_piecewise', 'calcGy', true, 'calcGp', false, ...
        'Gmatrices_intermediate', true, 'save_intermediates', false);
    %sensFunction_VDE = generateSensitivityFunction(datahandle, ...
    %    sol_rhs_test, FDstep, 'method', 'VDE', 'calcGy', true, 'calcGp', false, ...
    %    'Gmatrices_intermediate', true, 'save_intermediates', false);

    t_plot = 0:0.01:1;
    sensitivities_END_plot = sensFunction_ENDpiece(t_plot);
    %sensitivities_VDE_plot = sensFunction_VDE(t_plot);
    
end

if doMatlab
    t0 = 0; %#ok<UNRCH>
    tf = 0.5+0.1;
    timeinterval = [t0,tf];

    sol_ode45 = ode45(@(t,x) sign_inconsistent_rhs(t,x,p), timeinterval, initstates);
end


% Visualize solution
figure(1);
clf('reset');
grid on
ax1 = subplot(1,2,1); 
hold on;
if doIfdiff; plot(sol_rhs_test.x, sol_rhs_test.y(1,:)); end
if doMatlab; plot(sol_ode45.x, sol_ode45.y(1,:), 'Color', '#0f8f03', 'DisplayName', 'plain ode45'); end %#ok<UNRCH>
hold off;

% 
ax2 = subplot(1,2,2); 
hold on;
if doIfdiff
    plot(sol_rhs_test.x, sol_rhs_test.y(1,:), 'DisplayName', sprintf('ifdiff/%s', func2str(integrator)));
    plot(sw_points, sw_points_y, 'o', 'DisplayName', 'Switches'); 
end
if doMatlab
    plot(sol_ode45.x, sol_ode45.y(1,:), 'Color', '#0f8f03', 'DisplayName', 'plain ode45'); %#ok<UNRCH> 
end
legend('Location','South');
scale = 1e-5;
axis([0.5-0.001, 0.5+0.001, -scale, scale]);
hold off;


sgtitle('Inconsistently switching sign-equation');