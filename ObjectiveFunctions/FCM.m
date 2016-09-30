% function J = FCM(z, x, m) % where z are the clusters and x is a 3-d matrix representing an (rgb) image
  % jarcodiando...
  x = imread('testImg.png');
  x = permute(x, [1 3 2]);
  x = int32(reshape(x, size(x,1) * size(x,3), 3));
  m = 2;
  z = round(rand(4,3) * 255);
  k = size(z,1); % number of clusters
  
  %%%% Calculate the membership of each function.
  % x(i,j,:) is the rgb of a pixel
  mu = zeros(size(x,1), k);
  for j=1:size(x,1) % for each pixel
    for i=1:k # for each cluster
      s = 0;
      for L=1:k
        s += abs(z(i,:) .- x(j,:)).^(2/(m-1)) ./ abs(z(L,:) .- x(j,:));
      end
      mu(j,i) = 1/sum(s);
    end
  end
  
  %%%% Calculate the center of the clusters
  for i=1:k
    z(i,:) = sum(mu(:,i)*x)
  end
  
% end