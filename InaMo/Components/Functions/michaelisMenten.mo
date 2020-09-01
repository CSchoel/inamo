within InaMo.Components.Functions;
function michaelisMenten
  extends Modelica.Icons.Function;
  input SI.Concentration c;
  input SI.Concentration k;
  output Real rate(unit="1");
algorithm
  rate := c / (c + k);
end michaelisMenten;
