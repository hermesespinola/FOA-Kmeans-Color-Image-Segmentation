function z = func4(x)
  len = size(x, 2);
  sum = 0;
  for i=1:len
      sum = sum + (x(i)^2 - 10*cos(2*pi*x(i)));
  end
  z = 10*len + sum;
end