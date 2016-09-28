function out = FOA(problem, params)

  %% Problem Definition %%
  FitnessFunction = problem.FitnessFunction;  % Cost Function
  nVar = problem.nVar;                        % Number of unknow (Decision) variables (Dimensions)
  MaxValue = problem.MaxValue;                % minimum value for the problem
  MinValue = problem.MinValue;                % maximum value for the problem
  
  InitialTrees = params.InitialTrees;         % Number of Initial trees
  LifeTime = params.LifeTime;                 % life time of a tree
  LSC = params.LSC;                           % Local Seeding Changes, seeds that produce each tree in each iteration
  GSC = params.GSC;                           % number of variables that are changed randomly in global seeding
  TransferRate = params.TransferRate;         % Percentage of candidate population that produce Global Seeding
  AreaLimit = params.AreaLimit;               % limit of trees in the forest, remove the ones with worst fitness (Cost)
  MaxIter = params.MaxIter;                   % Stop Condition
  dLSC = params.dLSC;                         % LSC: max distance to drop the seed from the parent tree
  ShowIterInfo = params.ShowIterInfo;         % The Flag for Showing Iteration information
  
  candidatePopulation = [];
  
  %% 1. Initialization %%
  % Create a forest with InitialTrees and spread randomly in [MinValue, MaxValue]
  forest = [zeros(InitialTrees, 1) MinValue + rand(InitialTrees, nVar) * (MaxValue - MinValue)];

  %% 2. Main Loop of FOA %%
  for it=1:MaxIter
    % 2.1 Local Seeding
    oldTrees = [];
    forestSize = size(forest,1);    % Calculate the number of trees in the forest
    for tree=1:forestSize           % for each tree in the forest
      if forest(tree) == 0          % If the age of the tree is 0:
        dist = randn(1, nVar) * dLSC;           % Calculate a unit vector such that |dist| = rand(-dLSC, dLSC)
        seedPos = forest(tree, 2:end) + dist;   % add the tree position to the distance
        newTree = [0 seedPos];                  % create a new tree in the position of the seed
        forest(forestSize+1, :) = newTree;      % add the tree to the forest
      end
      forest(tree, 1) += 1;           % increase the age of the tree
    
      if forest(tree, 1) > LifeTime   % if the age of the tree with age biger than life time
        oldTrees(end+1) = tree;                         % add it to the list of old trees
        candidatePopulation(end+1,:) = forest(tree,:);  % add it to the candidate population
      end
    end
    
    % 2.2 Population limiting
    forest = forest(setdiff(1:end,oldTrees),:);                                 % remove the old trees

    fitness = cellfun(@(x)FitnessFunction(x), num2cell(forest'(2:end, :), 1));  % fitness (cost) of all trees
    forest = sort([fitness' forest])(:, 2:end);                                 % sort the trees according to their fitness
    
    if length(forest) > AreaLimit
      candidatePopulation(end+1:end+length(forest)-AreaLimit,:) = forest(AreaLimit+1:end, :);   % Add the exceding trees to the candidate population
      forest = forest(1:AreaLimit, :);                                                          % remove the exceding trees from the forest
    end
    
    % 2.3 Global Seeding
    globalParents = candidatePopulation(randperm(length(candidatePopulation), round(length(candidatePopulation)*TransferRate)), :); % Select "Transfer Rate" percent trees from the candidate population
    for i=1:size(globalParents,1) % for each selected tree
      % Choose GSC variables of the selected tree randomly
      globalSeed = [ 0 globalParents(i, 2:end) ];
      
      % Change the value of each variable with other randomly generated value in 
        % the variable's range
      for j=1:GSC
        globalSeed(randi([ 1 length(globalSeed) ],1,1)) = MinValue + rand * (MaxValue - MinValue); % FIXME: may select the same element several times
      end
      
      % add the new tree to the forest
      forest(end+1, :) = globalSeed;
    end
    
    % 2.4 Update the best so far tree
    % NOTE: the forest is already sorted
    forest(1) = 0; % set the age of the best tree to 0
    
    % Display Iteration Information
    if ShowIterInfo
      disp(['Iteration ' num2str(it) ': Best Tree = ' forest(1, :)]);
    end
  end

  %% Results %%
  out.Vals = forest(1, 2:end);
  out.Fitness = FitnessFunction(forest(1, 2:end));
  
end