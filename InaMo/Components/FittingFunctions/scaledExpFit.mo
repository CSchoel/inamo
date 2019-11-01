within InaMo.Components.FittingFunctions;
function scaledExpFit "exponential function with scaling parameters for x and y axis"
  input Real x "input value";
  input Real sx "scaling factor for x axis (fitting parameter)";
  input Real sy "scaling factor for y axis (fitting parameter)";
  output Real y "result";
algorithm
  y := sy * exp(sx * x);
end scaledExpFit;
