within InaMo.Components.Functions.Fitting;
function fsum "higher-order function for adding two arbitrary fitting functions"
  extends Modelica.Icons.Function;
  input Real x "input value";
  output Real y "output value";
  replaceable function fa = goldman "first fitting function";
  replaceable function fb = goldman "second fitting function";
algorithm
  y := fa(x) + fb(x);
end fsum;
