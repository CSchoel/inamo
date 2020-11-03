within InaMo.Components.Functions;
function hillLangmuir
  extends Modelica.Icons.Function;
  input SI.Concentration c "ligand concentration";
  input SI.Concentration ka "concentration producing half occupation";
  input Real n(unit="1") "Hill coefficient";
  output Real rate(unit="1");
algorithm
  rate := c^n / (c^n + ka^n);
end hillLangmuir;
