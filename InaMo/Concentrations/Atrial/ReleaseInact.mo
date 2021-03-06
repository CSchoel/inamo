within InaMo.Concentrations.Atrial;
model ReleaseInact "reaction of activator to inactive product"
  extends ReversibleReaction;
  parameter SI.Concentration ka "concentration producing half occupation";
  InaMo.Concentrations.Interfaces.SubstanceSite ca;
  parameter SI.Volume vol_ca "volume of calcium compartment";
equation
  ca.rate = 0;
  rate = 33.96 + 339.6 * hillLangmuir(ca.amount / vol_ca, ka, 4);
end ReleaseInact;
