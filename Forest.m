clc;
clear;
close all;

CostFunction = @(x) func6(x);  % Cost Function

maxIterations = 60;      %Stopping condition
minValue = -10;         %Lower limit of the space problem.
maxValue = 10;          %Upper limit of the space problem.
minLocalValue = -0.1;   %Lower limit for local seeding.
maxLocalValue = 0.1;    %Upper limit for local seeding.
initialTrees = 30;      %Initial number of trees in the forest.
nVar = 6;               %Number of variables to optimez.
lifeTime = 6;           %Limit age to be part of the candidate list.
LSC = 3;                %Local seeding: Number of seeds by tree. MUST BE: LSC <= nVar.
areaLimit = 100;        %Limit of trees in the forest.
transferRate = 0.01;    %Percentage of the trees in the candidate list that are going to global seed.
GSC = 2;                %Global seeding: Number of variables to be replaced by random numbers. MUST BE: GSC <= nVar.
maximaOrMinima = 1;     %Set -1 for maxima or 1 for minima.
lenCandidates = 0;      %Initial size of the candidateList
candidateList = [];     %List of candidate trees.

bestTreeByIteration = zeros(maxIterations, 1);   %List of best trees on each iteration

%_______________________________
%_age__|__x1__|__x2___|__cost__|


%1. Initialize
tree = [zeros(initialTrees, 1) minValue + rand(initialTrees, nVar)*(maxValue - minValue) zeros(initialTrees, 1)];

%2. Main loop
for i=1:maxIterations
      %2.1 Local seeding
      initialTrees = size(tree, 1);
      for j=1:initialTrees
         if tree(j, 1) == 0     %2.1 If is a new tree
             for k=1:LSC        %Creating LSC seeds
                 randomVariable = round(2+rand(1)*(nVar-1));
                 smallValue = minLocalValue+rand(1)*(maxLocalValue - minLocalValue);
                 sizeTree = size(tree, 1)+1;
                 newTree = tree(j, :);
                 newTree(1) = 0;
                 
                 if newTree(randomVariable) + smallValue < minValue
                     newTree(randomVariable) = minValue;
                 elseif newTree(randomVariable) + smallValue > maxValue
                     newTree(randomVariable) = maxValue;
                 else
                     newTree(randomVariable) = newTree(randomVariable) + smallValue;
                 end
                 
                 tree( sizeTree, : ) = newTree;
             end
         end
         tree(j, 1) = tree(j, 1) + 1;
      end
      %initialTrees = size(tree, 1);
      
      
      %2.2 Population limiting
      for j=1:size(tree, 1)
         %2.2.1 Remove trees with age bigger than life time and add them to candidate list
         if j > size(tree, 1)   %Para que no cause error al disminuir tree drasticamente
            break;
         end
         if tree(j, 1) > lifeTime
             sizeCandidateList = size(candidateList, 1)+1;
             candidateList(sizeCandidateList, :) = tree(j, :);
             tree = tree(setdiff(1:size(tree,1),j),:);
         end
      end
      
      %2.2.2 Sort tree according to fitness
      for j=1:size(tree, 1)
         tree(j, nVar+2) = CostFunction( tree(j, 2:(nVar+1)) ); 
      end
      tree = sortrows(tree, maximaOrMinima*(nVar+2));
      
      %2.2.3 Remove tree that exceed area limit and add them to candidate list
      if size(tree, 1) > areaLimit
          candidateList(end+1:end+size(tree, 1)-areaLimit, :) = tree(areaLimit+1:end, :);
          tree = tree(1:areaLimit, :);
          %candidateList = [candidateList; tree(areaLimit+1:size(tree, 1), :)];
          %tree = tree(setdiff(1:size(tree,1),[areaLimit+1, size(tree, 1)]),:);
      end
      
      
      %2.3 Global seeding
      %2.3.1 Choose number of trees from candidate tree
      selectedTrees = round(transferRate * size(candidateList, 1));
      
      %2.3.1 Create new trees -modificar
      for j=1:selectedTrees
          sizeTree = size(tree, 1)+1;
          newTree = tree(j, :);
          newTree(1) = 0;
          for k=1:GSC
              randomVariable = round(2+rand(1)*(nVar-1));
              smallValue = minValue+rand(1)*(maxValue - minValue);
              newTree(randomVariable) = smallValue;
          end
          tree( sizeTree, : ) = newTree;
      end
      
      %LIMITING CANDIDATE LIST
      %candidateList = candidateList(1:20, :);
      
      %2.4 Update best tree
      %tree = sortrows(tree, maximaOrMinima*(nVar+2));
      tree(1, 1) = 0;
      
      bestTreeByIteration(i) = tree(1, nVar+2);
end

%Show info
figure;
semilogy(bestTreeByIteration, 'LineWidth', 2);
xlabel('Iteration');
ylabel('BestTreeCost');
grid on;


