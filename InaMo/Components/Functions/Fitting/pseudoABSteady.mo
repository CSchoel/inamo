within InaMo.Components.Functions.Fitting;
function pseudoABSteady "uses pseudo alpha and beta functions to calculate steady state"
  extends Modelica.Icons.Function;
  replaceable function falpha = scaledExpFit;
  replaceable function fbeta = scaledExpFit;
  input Real x;
  output Real y;
algorithm
  y := falpha(x) / (falpha(x) + fbeta(x));
end pseudoABSteady;
