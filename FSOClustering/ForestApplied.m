clc;
clear;
close all;

im = double(imread('icon.png'));

%arr = transpose(squeeze(im(1,:,:)));

CostFunction = @(x, image) kmeans(x, image);  % Cost Function

maxIterations = 6;      %Stopping condition
minValue = 0;         %Lower limit of the space problem.
maxValue = 255;          %Upper limit of the space problem.
minLocalValue = -5;   %Lower limit for local seeding.
maxLocalValue = 5;    %Upper limit for local seeding.
initialTrees = 30;      %Initial number of trees in the forest.
nVar = 3;               %Number of clusters
lifeTime = 6;           %Limit age to be part of the candidate list.
LSC = 3;                %Local seeding: Number of seeds by tree. MUST BE: LSC <= nVar.
areaLimit = 100;        %Limit of trees in the forest.
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
      %2.1 Local seeding
      
      initialTrees = size(tree, 1);
      for j=1:initialTrees
         if tree(j, 1, 1) == 0     %2.1 If is a new tree
             for k=1:LSC        %Creating LSC seeds
                 randomVariable = round(2+rand(1)*(nVar-1));
                 smallValue = round(minLocalValue+rand(1)*(maxLocalValue - minLocalValue));
                 sizeTree = size(tree, 1)+1;
                 newTree = tree(j, :, :);
                 newTree(1, 1, 1) = 0;
                 
                 %Modifica sólo el componente R (el ultimo valor de newTree (1))
                 if newTree(1, randomVariable, 1) + smallValue < minValue
                     newTree(1, randomVariable, 1) = minValue;
                 elseif newTree(1, randomVariable, 1) + smallValue > maxValue
                     newTree(1, randomVariable, 1) = maxValue;
                 else
                     newTree(1, randomVariable, 1) = newTree(1, randomVariable, 1) + smallValue;
                 end
                 
                 tree( sizeTree, :, : ) = newTree;
             end
         end
         tree(j, 1, 1) = tree(j, 1, 1) + 1;
      end
      
      
      
      %2.2 Population limiting
      for j=1:size(tree, 1)
         %2.2.1 Remove trees with age bigger than life time and add them to candidate list
         if j > size(tree, 1)   %Para que no cause error al disminuir tree drasticamente
            break;
         end
         if tree(j, 1, 1) > lifeTime
             sizeCandidateList = size(candidateList, 1)+1;
             %candidateList = vertcat(candidateList, tree(j, :, :));
             candidateList(sizeCandidateList, :, :) = tree(j, :, :);
             tree(j, :, :) = [];
         end
      end
      
%       tree
      
      %2.2.2 Sort tree according to fitness
      for j=1:size(tree, 1)
         tree(j, nVar+2, 1) = CostFunction( transpose(squeeze(tree(j, 2:(nVar+1), :))), im );
         tree(j, nVar+2, 2) = tree(j, nVar+2, 1);
         tree(j, nVar+2, 3) = tree(j, nVar+2, 1);
      end
      
      %Sorting
      z=tree(:,nVar+2,:);
      [values,indices] = sort(z,1) ;
      B=zeros(size(tree,1),size(tree,2),size(tree,3));
      for j=1:size(tree,3)
        B(:,:,j) =tree(indices(:,:,j),:,j);
      end
      tree = B;
      %End sorting
      
      
      
      %2.2.3 Remove tree that exceed area limit and add them to candidate list
      if size(tree, 1) > areaLimit
         %candidateList(size(tree, 1)+1:size(candidateList)+size(tree, 1)-areaLimit, :, :) = tree(areaLimit+1:size(tree, 1), :, :);
        %candidateList = vertcat(candidateList(size(tree, 1)+1:size(candidateList)+size(tree, 1)-areaLimit, :, :), tree(areaLimit+1:size(tree, 1), :, :));
         candidateList = vertcat(candidateList, tree(areaLimit+1:size(tree, 1), :, :));
          tree(areaLimit+1:size(tree, 1), :, :) = [];
      end
      
%       candidateList
%         tree
        
      
      %2.3 Global seeding
      %2.3.1 Choose number of trees from candidate tree
      selectedTrees = round(transferRate * size(candidateList, 1));
      
      %2.3.1 Create new trees
      for j=1:selectedTrees
          sizeTree = size(tree, 1)+1;
          newTree = tree(j, :, :);
          newTree(1, 1, 1) = 0;
          for k=1:GSC
              %Solo modifico el componente R
              randomVariable = round(2+rand(1)*(nVar-1));
              smallValue = round(minValue+rand(1)*(maxValue - minValue));
              newTree(1, randomVariable, 1) = smallValue;
          end
          tree( sizeTree, :, : ) = newTree;
      end
      
      
      %2.4 Update best tree
      tree(1, 1, 1) = 0;
      bestTreeByIteration(i) = tree(1, nVar+2, 1);
      
      
end

bestTreeByIteration(1)
bestTreeByIteration(maxIterations)

%Show info
figure;
semilogy(bestTreeByIteration, 'LineWidth', 2);
xlabel('Iteration');
ylabel('BestTreeCost');
grid on;


