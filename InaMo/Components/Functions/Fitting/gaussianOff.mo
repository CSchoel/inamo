within InaMo.Components.Functions.Fitting;
function gaussianOff "gaussian function with offset"
  extends Modelica.Icons.Function;
  input Real x "input value";
  input Real y_min = 0 "lower asymptote (fitting parameter)";
  input Real y_max = 1 "upper asmyptote when d_off=1 and nu=1 (fititng parameter)";
  input Real x0 = 0 "x-value of sigmoid midpoint when d_off=1 and nu=1 (fitting parameter)";
  input Real sx = 1 "scaling factor for x axis (i.e. steepness, fitting parameter)";
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and scaling factor";
algorithm
  x_adj := sx * (x - x0);
  y := y_min + (y_max - y_min) * exp(-(x_adj ^ 2));
end gaussianOff;
