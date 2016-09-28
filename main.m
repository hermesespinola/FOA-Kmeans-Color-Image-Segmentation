clc;
clear;
close all;

problem.FitnessFunction = @(x) minimizeFunction(x);  % The new cost function
problem.nVar = 6;                                    % dimensions of the problem
problem.MinValue = -10;
problem.MaxValue = 10;

params.InitialTrees = 10;
params.LifeTime = 4;
params.LSC = 3;
params.GSC = 2;
params.TransferRate = 0.2;
params.MaxIter = 50;
params.dLSC = 2;
params.AreaLimit = 30;
params.ShowIterInfo = false; % Flag for Showing Iteration Information

%% Calling FOA

out = FOA(problem, params);

BestSol = out.Vals;
BestFitness = out.Fitness;

%% Results


