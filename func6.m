function z = func6(x)
  A = [10 3 17 3.5 1.7 8;
       0.05 10 17 0.1 8 14;
       3 3.5 1.7 10 17 8;
       17 8 0.05 10 0.1 14];
       
  P = 0.0001*[1312 1696 5596 124 8283 5886;
              2329 4135 8307 3736 1004 9991;
              2348 1451 3522 2883 3047 6650;
              4047 8828 8732 5743 1091 381];
              
  alfa = [1.0; 1.2; 3.0; 3.2];
  
  suma = 0.0;
  for i=1:4
      temp = 0.0;
    for j=1:6
      temp = temp + (A(i, j) * ( x(j) - P(i, j) )^2);
    end
    suma = suma + alfa(i) * exp( - temp);
  end
  
  z = -suma;
  
end