within InaMo.Functions.Biological;
function michaelisMenten "equation for enzymatic reactions following Michaelis-Menten kinetics"
  extends Modelica.Icons.Function;
  input SI.Concentration s "substrate concentration";
  input SI.Concentration k "concentration producing half-maximum reaction rate (michaelis constant)";
  output Real rate(unit="1") "reaction rate";
algorithm
  rate := s / (s + k);
end michaelisMenten;
