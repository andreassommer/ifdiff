%% Solution ifdiff

integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-6);
datahandle    = prepareDatahandleForIntegration('rhsCabbage', 'integrator', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 118];
initialvalues = [2.48252;0;0];
parameters_ODE = getParamsCabbage();
sol = solveODE(datahandle, tspan, initialvalues, parameters_ODE);

%% Precalculations for finite differences for sensitivities
dim_y = size(sol.y, 1);
dim_p = length(parameters_ODE);
FDstep = generateFDstep(dim_y, dim_p);

%% Method for sensitivity calculations
method = 'VDE';

%% Plot sensitivities initial values 
sensitivities_function = generateSensitivityFunction(datahandle, sol, 'FDstep', FDstep, 'calcGp', false, 'method', method, 'p_typ', parameters_ODE);
t_sens = 0:0.1:118;
sensitivites = sensitivities_function(t_sens);

%%
figure(1)
clf

% Extract Gy matrices
GyCell = arrayfun(@(s) s.Gy, sensitivites, 'UniformOutput', false);
Gy = cat(3, GyCell{:});

labels = 'LSH';
set(gcf, 'Position', [100 100 1100 850]);

for row = 1:3
    for col = 1:3
        subplot(3,3,(row-1)*3 + col)

        plot(t_sens, squeeze(Gy(row,col,:)), '.', 'Color', [0.1 0.35 0.8], 'MarkerSize', 7);

        if col == 1
            ylim([0 500])
        else
            ylim([-1 1.5])
        end
        xlim([0 118])

        xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 13)
        ylabel(sprintf('$\\partial y_{%s}(t)/\\partial y_{0,%s}$', labels(row), labels(col)), 'Interpreter', 'latex', 'FontSize', 13)
        title(sprintf('$G_{y,%d%d}(t;t_0)$', row, col), 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'normal')
        set(gca, ...
            'FontSize', 11, ...
            'LineWidth', 1, ...
            'Box', 'off', ...
            'TickDir', 'out', ...
            'TickLength', [0.015 0.015])

        grid on
        set(gca, 'GridAlpha', 0.15)

    end
end

%% Plot sensitivities parameters
sensitivities_function_p = generateSensitivityFunction(datahandle, sol, 'FDstep', FDstep, 'calcGy', false, 'method', method, 'p_typ', parameters_ODE);
t_sens = 0:0.1:118;
ticid = tic;
sensitivites = sensitivities_function_p(t_sens);
toc(ticid);
%%
figure(2)
clf

% Extract all Gp matrices
GpCell = arrayfun(@(s) s.Gp, sensitivites, 'UniformOutput', false);
Gp = cat(3, GpCell{:});

labels = 'LSH';

cols = [1 5 6];

ylims = [
     0     0.02
   -20   150
     0  4000
];

paramLabels = {'a', 'r_S', 'r_H'};
set(gcf, 'Position', [100 100 1100 850]);

for row = 1:3
    for j = 1:3
        col = cols(j);
        subplot(3,3,(row-1)*3 + j)
        plot(t_sens, squeeze(Gp(row,col,:)), '.', 'Color', [0.1 0.35 0.8], 'MarkerSize', 7);

        xlim([0 118])
        ylim(ylims(j,:))

        xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 13)
        ylabel(sprintf('$\\partial y_{%s}(t)/\\partial %s$', labels(row), paramLabels{j}), 'Interpreter', 'latex', 'FontSize', 13)
        title(sprintf('$G_{p,%d%d}(t;t_0)$', row, col), 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'normal')
        set(gca, ...
            'FontSize', 11, ...
            'LineWidth', 1, ...
            'Box', 'off', ...
            'TickDir', 'out', ...
            'TickLength', [0.015 0.015])

        grid on
        set(gca, 'GridAlpha', 0.15)
    end
end