clc;
clear;
close all;

problem.FitnessFunction = @(x) minimizeFunction(x);  % The new cost function
problem.nVar = 6;                                    % dimensions of the problem
problem.MinValue = -10;
problem.MaxValue = 10;

params.InitialTrees = 30;
params.LifeTime = 6;
params.LSC = 3;
params.GSC = 2;
params.TransferRate = 0.01;
params.MaxIter = 50;
params.dLSC = 0.1;
params.AreaLimit = 100;
params.ShowIterInfo = true; % Flag for Showing Iteration Information

%% Calling FOA

out = FOA(problem, params);

BestSol = out.Vals;
BestFitness = out.Fitness;
BestSols = out.BestSols;

%% Results
figure;
plot(BestSols, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

