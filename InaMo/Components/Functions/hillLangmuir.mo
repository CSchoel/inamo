within InaMo.Components.Functions;
function hillLangmuir
  input SI.Concentration c "ligand concentration";
  input SI.Concentration ka "concentration producing half occupation";
  input SI.Concentration n "Hill coefficient";
  output Real rate;
algorithm
  rate := c^n / (c^n + k^n);
end hillLangmuir;
