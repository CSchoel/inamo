within InaMo.Components.Functions.Fitting;
function fprod
  input Real x;
  output Real y;
  replaceable function fa = goldmanFit;
  replaceable function fb = goldmanFit;
algorithm
  y := fa(x) * fb(x);
end fprod;
