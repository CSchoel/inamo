within InaMo.Components.Functions.Fitting;
function fprod "higher-order function for multiplying two arbitrary fitting functions"
  extends Modelica.Icons.Function;
  input Real x "input value";
  output Real y "output value";
  replaceable function fa = goldmanFit "first fitting function";
  replaceable function fb = goldmanFit "second fitting function";
algorithm
  y := fa(x) * fb(x);
end fprod;
