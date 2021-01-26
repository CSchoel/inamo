within InaMo.Functions.Biological;
function hillLangmuir "Hill-Langmuir equation measuring the occupancy of a molecule by a ligand"
  extends Modelica.Icons.Function;
  input SI.Concentration c "ligand concentration";
  input SI.Concentration ka "concentration producing half occupation";
  input Real n(unit="1") "Hill coefficient";
  output Real rate(unit="1") "occupancy of molecule by ligand";
algorithm
  rate := c^n / (c^n + ka^n);
end hillLangmuir;
