function z = kmeans(x)
global im;
  total = 0.0;
  for i=1:size(x, 2)
    for j=1:size(im, 1)
      for k=1:size(im, 2)
          total = total + sum((x(:, i) - im(j, k, :)).^2);
      end
    end
  end
  z = sum(total);
end