clc;
clear;
close all;

addpath('../ObjectiveFunctions/'); % add the Objective Functions to the path

problem.CostFunction = @(x) ObjFun2(x);  % The new cost function
problem.nVar = 6;                     % Number of unknown (Decision) variables
problem.VarMin = -10;

problem.VarMin =  0;  % Lower Bound of Decision Variables
problem.VarMax =  1;   % Upper Bound of Decision Variables

%% Parameters of PSO

params.MaxIt = 100;        % Maximum Number of Iterations
params.nPop = 50;           % Population Size (Swarm Size)
params.w = 0.8;               % Intertia Coefficient
params.wdamp = 0.90;        % Damping Ratio of Inertia Coefficient
params.c1 = 1;              % Personal Acceleration Coefficient
params.c2 = 2;              % Social Acceleration Coefficient
params.ShowIterInfo = false; % Flag for Showing Iteration Information

%% Calling PSO

out = pso(problem, params);

BestSol = out.BestSol;
BestCosts = out.BestCosts;

%% Results

figure;

semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
