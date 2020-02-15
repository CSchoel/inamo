within InaMo.Components.Functions.Fitting;
function reciprocalRatioFit
  input Real x "input value";
  input Real x0 = 0 "x value where y = 0.5 (fitting parameter)";
  output Real y "result";
algorithm
  y := x / (x + x0);
end reciprocalRatioFit;
