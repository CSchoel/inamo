within InaMo.Components.Functions.Fitting;
function expFit "exponential function that can be shifted on x-axis and scaled on both axes"
  extends Modelica.Icons.Function;
  input Real x "input value";
  input Real x0 = 0 "x-value where y = 1 (fitting parameter)";
  input Real sx = 1 "scaling factor for x axis (fitting parameter)";
  input Real sy = 1 "scaling factor for y axis (fitting parameter)";
  output Real y "result";
algorithm
  y := sy * exp(sx * (x - x0));
end expFit;
