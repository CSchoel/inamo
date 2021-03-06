within InaMo.Concentrations.Atrioventricular;
model RyanodineReceptor "ryanodine receptor kinetics for Ca2+ release by the SR"
  extends InaMo.Icons.InsideBottomOutsideTop;
  extends InaMo.Icons.LipidBilayerWithGap;
  extends InaMo.Icons.Activatable;
  extends InaMo.Concentrations.Interfaces.InactiveChemicalTransport;
  extends InaMo.Icons.Current(current_name="RyR");
  parameter Real p(quantity="reaction rate coefficient", unit="1/s") "rate coefficient (inverse of time constant)";
  parameter SI.Concentration ka "concentration producing half occupation";
  parameter Real n(unit="1") "Hill coefficient";
equation
  coeff = p * hillLangmuir(dst.amount / vol_dst, ka, n);
end RyanodineReceptor;
