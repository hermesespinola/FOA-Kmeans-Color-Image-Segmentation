clc;
clear;
close all;

%% Problem Definition
CostFunction = @(x) rosenbrock(x);  % Cost Function
nVar = 5;                       % Number of unknow (Decision) variables (Dimensions)

VarSize = [1 nVar];             % Matrix size of Decision Variables (horizontal vector)

VarMin = -10;                   % Lower bound of Decision Variables
VarMax = 10;                    % Upper Bound of Decision Variables

%% Parameters of PSO
MaxIt = 1000;                    % Maximum number of iteration
nPop = 50;                      % Number of particles in the population (Swarm size)
w = 1;                          % Inertia Coefficient (Weight)
wdamp = 0.99;                    % Damping Ratio of Inertia Coefficient
c1 = 2;                         % Personal Acceleration Coefficient
c2 = 2;                         % Social Acceleration Coefficient

%% Initialization

% Particle template
empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Cost = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

% Create population array
particle = repmat(empty_particle, nPop, 1); % repeat the element nPop rows and 1 column

% Initialization global best
GlobalBest.Cost = inf;

% initialize population members
for i=1:nPop
  % initialize all position vectors between the lower and upper bounds
  particle(i).Position = unifrnd(VarMin, VarMax, VarSize);
  
  % Initial Velocty
  particle(i).Velocity = zeros(VarSize);
  
  % Evaluation of the cost function in the initial random position
  particle(i).Cost = CostFunction(particle(i).Position);
  
  % Update the personal best
  particle(i).Best.Position = particle(i).Position;
  particle(i).Best.Cost = particle(i).Cost;
  
  % Update Global Best
  if particle(i).Best.Cost < GlobalBest.Cost
    GlobalBest = particle(i).Best;
   end
end

% Array yo hold best value on each Iteration
BestCosts = zeros(MaxIt, 1);

%% Main Loop of PSO
for it=1:MaxIt
  for i=1:nPop
    % update velocity
    particle(i).Velocity = w*particle(i).Velocity ...
    + c1*rand(VarSize) .* (particle(i).Best.Position - particle(i).Position) ...
    + c2*rand(VarSize) .* (GlobalBest.Position - particle(i).Position);
    
    % update position
    particle(i).Position = particle(i).Position + particle(i).Velocity;
    
    % Evaluation
    particle(i).Cost = CostFunction(particle(i).Position);
    
    % Update personal best
    if particle(i).Cost < particle(i).Best.Cost
      particle(i).Best.Position = particle(i).Position;
      particle(i).Best.Cost = particle(i).Cost;
      
      % update global best
      if particle(i).Best.Cost < GlobalBest.Cost
        GlobalBest = particle(i).Best;
      end
      
    end
  end
  
  % Store the best Cost Value
  BestCosts(it) = GlobalBest.Cost;
  
  % Display Iteration Information
  % disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
  
  % Damping Inertia Coefficient
  w = w * wdamp;
end

%% Results

figure;
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('BestCost');
grid on;
