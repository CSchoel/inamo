within InaMo.Components.Functions.Fitting;
function pseudoABTau "uses pseudo alpha and beta functions to calculate time constant"
  replaceable function falpha = scaledExpFit;
  replaceable function fbeta = scaledExpFit;
  input Real x;
  output Real y;
algorithm
  y := 1 / (falpha(x) + fbeta(x));
end pseudoABTau;
