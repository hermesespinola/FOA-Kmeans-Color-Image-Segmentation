function z = kmeans(x, image)
  total = 0.0;
  for i=1:size(x, 2)
    for k=1:size(image, 1)
      for l=1:size(image, 2)
          total = total + sum((x(:, i) - image(k, l, :)).^2);
      end
    end
  end
  z = sum(total);
end