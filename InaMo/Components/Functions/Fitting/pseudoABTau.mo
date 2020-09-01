within InaMo.Components.Functions.Fitting;
function pseudoABTau "uses pseudo alpha and beta functions to calculate time constant"
  extends Modelica.Icons.Function;
  replaceable function falpha = scaledExpFit;
  replaceable function fbeta = scaledExpFit;
  input Real x;
  input Real off = 0 "offset";
  output Real y;
algorithm
  y := 1 / (falpha(x) + fbeta(x)) + off;
end pseudoABTau;
