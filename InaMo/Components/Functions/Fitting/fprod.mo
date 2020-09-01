within InaMo.Components.Functions.Fitting;
function fprod
  extends Modelica.Icons.Function;
  input Real x;
  output Real y;
  replaceable function fa = goldmanFit;
  replaceable function fb = goldmanFit;
algorithm
  y := fa(x) * fb(x);
end fprod;
