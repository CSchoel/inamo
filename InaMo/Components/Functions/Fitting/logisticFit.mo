within InaMo.Components.Functions.Fitting;
function logisticFit "logistic function"
  input Real x "input value";
  input Real x0 = 0 "x-value of sigmoid midpoint (fitting parameter)";
  input Real sx = 1 "scaling factor for x axis (i.e. steepness, fitting parameter)";
  input Real L = 1 "maximum value (fitting parameter)";
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and scaling factor";
algorithm
  x_adj := k * (x - x0);
  y := L / (exp(-x_adj) + 1);
end logisticFit;
