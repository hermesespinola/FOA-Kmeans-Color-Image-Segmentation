function z = minimizeFunction2(x)
  beta = 2;
    
  suma = 0.0;
  for j=1:1
      for i=1:6
          a = i;
          b = j;
          if -a <= x(a)
            suma = suma + (a^b+beta)*((x(a)/a)^2-1);
          else
              break
          end
      end
  end
  
  z = suma;
  
end