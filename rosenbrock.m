% Función de Rosenbrock%Erik Cuevas, Valentín Osuna-Enciso, Diego Oliva, Margarita Díaz
% Función que recibe un vector x n-dimensional

function fx = rosenbrock(x)%Número de dimensiones 2 para este problema
n = 2;sum = 0;

%Función de Rosenbrock
for j = 1:n-1;  
  sum = sum+100*(x(j)^2-x(j+1))^2+(x(j)-1)^2; 
end 

%Regresa el valor de la función objetivo
fx = sum;