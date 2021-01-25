within InaMo.Components.Functions.Fitting;
function gaussianOff "gaussian function with freely adjustable amplitude and offset"
  extends Modelica.Icons.Function;
  input Real x "input value";
  input Real y_min = 0 "minimum value achieved at edges (fitting parameter)";
  input Real y_max = 1 "maximum value achieved at peak (fititng parameter)";
  input Real x0 = 0 "x-value of bell curve midpoint (fitting parameter)";
  input Real sigma = 1 "standard deviation determining the width of the bell curve (fitting parameter)";
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and standard deviation";
algorithm
  x_adj := (x - x0)/sigma;
  y := y_min + (y_max - y_min) * exp(-0.5*(x_adj ^ 2));
end gaussianOff;
