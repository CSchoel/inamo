within InaMo.Components.Functions.Fitting;
function gaussianOff "gaussian function with freely adjustable amplitude and offset"
  extends Modelica.Icons.Function;
  input Real x "input value";
  input Real y_min = 0 "lower asymptote (fitting parameter)";
  input Real y_max = 1 "upper asmyptote when d_off=1 and nu=1 (fititng parameter)";
  input Real x0 = 0 "x-value of sigmoid midpoint when d_off=1 and nu=1 (fitting parameter)";
  input Real sigma = 1; //1/sx/sqrt(2);
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and scaling factor";
algorithm
  x_adj := (x - x0)/sigma;
  y := y_min + (y_max - y_min) * exp(-0.5*(x_adj ^ 2));
end gaussianOff;
