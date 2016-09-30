clc;
clear;
close all;

global im;
im = double(imread('icon.png'));
imshow(im);
im = imresize(im, [300 300]);
row = size(im, 1);
col = size(im, 2);
im = reshape(im, [row*col 3]);

CostFunction = @(x) kmeans(x);  % Cost Function

maxIterations = 10;     %Stopping condition
minValue = 0;           %Lower limit of the space problem.
maxValue = 255;         %Upper limit of the space problem.
minLocalValue = -5;     %Lower limit for local seeding.
maxLocalValue = 5;      %Upper limit for local seeding.
initialTrees = 30;      %Initial number of trees in the forest.
nVar = 3;               %Number of clusters
lifeTime = 6;           %Limit age to be part of the candidate list.
LSC = 3;                %Local seeding: Number of seeds by tree.
areaLimit = 50;         %Limit of trees in the forest.
transferRate = 0.01;    %Percentage of the trees in the candidate list that are going to global seed.
GSC = 2;                %Global seeding: Number of variables to be replaced by random numbers. MUST BE: GSC <= nVar.
maximaOrMinima = 1;     %Set -1 for maxima or 1 for minima.
candidateList = [];     %List of candidate trees.

bestTreeByIteration = zeros(maxIterations, 1);   %List of best trees on each iteration

%_______________________________
%_age__|__x1__|__x2___|__cost__|


%1. Initialize
tree = [zeros(initialTrees, 1) round(minValue + rand(initialTrees, nVar)*(maxValue - minValue)) zeros(initialTrees, 1)];
tree(:, :, 2) = [zeros(initialTrees, 1) round(minValue + rand(initialTrees, nVar)*(maxValue - minValue)) zeros(initialTrees, 1)];
tree(:, :, 3) = [zeros(initialTrees, 1) round(minValue + rand(initialTrees, nVar)*(maxValue - minValue)) zeros(initialTrees, 1)];

%2. Main loop
for i=1:maxIterations
      tic
      %2.1 Local seeding
      initialTrees = size(tree, 1);
      for j=1:initialTrees
         if tree(j, 1, 1) == 0     %2.1 If is a new tree
             for k=1:LSC           %Creating LSC seeds
                 randomVariable = round(2+rand(1)*(nVar-1));
                 smallValue = round(minLocalValue+rand(1)*(maxLocalValue - minLocalValue));
                 sizeTree = size(tree, 1)+1;
                 newTree = tree(j, :, :);
                 newTree(1, 1, 1) = 0;
                 
                 %Random RGB variable
                 randomRGB = randi([1 3]);
                 
                 %Modifica una variable RGB de un cluster
                 if newTree(1, randomVariable, randomRGB) + smallValue < minValue
                     newTree(1, randomVariable, randomRGB) = minValue;
                 elseif newTree(1, randomVariable, randomRGB) + smallValue > maxValue
                     newTree(1, randomVariable, randomRGB) = maxValue;
                 else
                     newTree(1, randomVariable, randomRGB) = newTree(1, randomVariable, randomRGB) + smallValue;
                 end
                 
                 tree( sizeTree, :, : ) = newTree;
             end
         end
         tree(j, 1, 1) = tree(j, 1, 1) + 1;
      end
      
      %2.2 Population limiting
      for j=1:size(tree, 1)
         %2.2.1 Remove trees with age bigger than life time and add them to candidate list
         if j > size(tree, 1)
            break;
         end
         if tree(j, 1, 1) > lifeTime
             sizeCandidateList = size(candidateList, 1)+1;
             candidateList(sizeCandidateList, :, :) = tree(j, :, :);
             tree(j, :, :) = [];
         end
      end
      
      %2.2.2 Sort tree according to fitness
      for j=1:size(tree, 1)
         tree(j, nVar+2, 1) = CostFunction( transpose(squeeze(tree(j, 2:(nVar+1), :))) );
         tree(j, nVar+2, 2) = tree(j, nVar+2, 1);
         tree(j, nVar+2, 3) = tree(j, nVar+2, 1);
      end
      %Sorting
      tree(:, :, 1) = sortrows(tree(:, :, 1), nVar+2);
      tree(:, :, 2) = sortrows(tree(:, :, 2), nVar+2);
      tree(:, :, 3) = sortrows(tree(:, :, 3), nVar+2);
      %End sorting
      
      %2.2.3 Remove tree that exceed area limit and add them to candidate list
      if size(tree, 1) > areaLimit
         candidateList(size(candidateList, 1)+1:size(candidateList, 1)+size(tree, 1)-areaLimit, :, :) = tree(areaLimit+1:size(tree, 1), :, :);
          tree(areaLimit+1:size(tree, 1), :, :) = [];
      end
      
      %2.3 Global seeding
      %2.3.1 Choose number of trees from candidate tree
      selectedTrees = floor(transferRate * size(candidateList, 1));
      globalParents = randperm(selectedTrees);
      
      %2.3.1 Create new trees
      for j=1:selectedTrees
          sizeTree = size(tree, 1)+1;
          newTree = candidateList(globalParents(1, j), :, :);
          newTree(1, 1, 1) = 0;
          for k=1:GSC
              %Random RGB variable
              randomRGB = randi([1 3]);
              randomVariable = round(2+rand(1)*(nVar-1));
              smallValue = round(minValue+rand(1)*(maxValue - minValue));
              newTree(1, randomVariable, randomRGB) = smallValue;
          end
          tree( sizeTree, :, : ) = newTree;
      end
      
      %Limiting candidateList
      candidateList = [];
      
      %2.4 Update best tree
      tree(1, 1, 1) = 0;
      
      bestTreeByIteration(i) = tree(1, nVar+2, 1);
      
      disp(fprintf('Iteration: %d in time: %f cost: %f', i, toc, bestTreeByIteration(i)));
end

%Show info
figure;
plot(bestTreeByIteration, 'LineWidth', 2);
% semilogy(bestTreeByIteration, 'LineWidth', 2);
title 'Forest optimization algorithm for image clustering';
xlabel('Iteration');
ylabel('Best tree cost');
grid on;
