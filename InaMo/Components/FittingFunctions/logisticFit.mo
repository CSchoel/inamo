within InaMo.Components.FittingFunctions;
function logisticFit "logistic function"
  input Real x "input value";
  input Real x0 "x-value of sigmoid midpoint (fitting parameter)";
  input Real sx "scaling factor for x axis (i.e. steepness, fitting parameter)";
  input Real L "maximum value (fitting parameter)";
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and scaling factor";
algorithm
  x_adj := k * (x - x0);
  y := L / (exp(-x_adj) + 1);
end logisticFit;
