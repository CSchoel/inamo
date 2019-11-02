within InaMo.Components.FittingFunctions;
function generalizedLogisticFit "generalized logistic function"
  input Real x "input value";
  input Real y_min "lower asymptote (fitting parameter)";
  input Real y_max "upper asmyptote when d_off=1 and nu=1 (fititng parameter)";
  input Real x0 "x-value of sigmoid midpoint when d_off=1 and nu=1 (fitting parameter)";
  input Real sx "scaling factor for x axis (i.e. steepness, fitting parameter)";
  input Real se "scaling factor for exponential part (fitting parameter)";
  input Real d_off = 1 "offset in denominator (affects upper asymptote, fitting parameter)";
  input Real nu = 1 "reciprocal of exponent of denominator (affects upper asymptote, fitting parameter)";
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and scaling factor";
algorithm
  x_adj := sx * (x - x0);
  y := y_min + (y_max - y_min) / (se * exp(-x_adj) + d_off) ^ (1/nu);
end generalizedLogisticFit;
