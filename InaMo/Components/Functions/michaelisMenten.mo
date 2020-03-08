within InaMo.Components.Functions;
function michaelisMenten
  input SI.Concentration c;
  input SI.Concentration k;
  output Real rate;
algorithm
  rate := c / (c + k);
end michaelisMenten;
