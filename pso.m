function out = pso(problem, params)

  %% Problem Definition %%
  CostFunction = problem.CostFunction;  % Cost Function
  nVar = problem.nVar;                  % Number of unknow (Decision) variables (Dimensions)

  VarSize = [1 nVar];                   % Matrix size of Decision Variables (horizontal vector)

  VarMin = problem.VarMin;	            % Lower Bound of Decision Variables
  VarMax = problem.VarMax;              % Upper Bound of Decision Variables

  %% Parameters of PSO %%
  MaxIt = params.MaxIt;                 % Maximum Number of iterations
  nPop = params.nPop;                   % Number of particles in the population (Swarm size)
  w = params.w;                         % Inertia Coefficient (Weight)
  wdamp = params.wdamp;                 % Damping Ratio of Inertia Coefficient
  c1 = params.c1;                       % Personal Acceleration Coefficient
  c2 = params.c2;                       % Social Acceleration Coefficient

  % The Flag for Showing Iteration information
  ShowIterInfo = params.ShowIterInfo;
  
  %% Initialization %%
  
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

  %% Main Loop of PSO %%
  for it=1:MaxIt
    for i=1:nPop
      % update velocity
      particle(i).Velocity = w*particle(i).Velocity ...
      + c1*rand(VarSize) .* (particle(i).Best.Position - particle(i).Position) ...
      + c2*rand(VarSize) .* (GlobalBest.Position - particle(i).Position);
      
      % update position
      particle(i).Position = particle(i).Position + particle(i).Velocity;
      
      % Apply Lower and Upper bound limits
      particle(i).Position = max(particle(i).Position, VarMin);
      particle(i).Position = min(particle(i).Position, VarMax);
      
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
    if ShowIterInfo
      disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
    end
    
    % Damping Inertia Coefficient
    w = w * wdamp;
  end

  %% Results %%
  
  out.pop = particle;
  out.BestSol = GlobalBest;
  out.BestCosts = BestCosts;
end