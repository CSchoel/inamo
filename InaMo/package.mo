package InaMo
  import SI = Modelica.SIunits;
  type PermeabilityFM = Real(
    final quantitiy="Permeability (fluid mechanics)",
    final unit="m3/(s.m2)";
  );
  constant SI.Area unitArea = 1;
end InaMo;
