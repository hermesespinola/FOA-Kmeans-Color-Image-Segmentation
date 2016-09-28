function z = func(x)
  sum = 0.0;
  for i=1:size(x, 2)
    sum = sum + x(i)*sin(sqrt(abs(x(i))));
  end
  z = 418.9829*size(x, 2) - sum;
end