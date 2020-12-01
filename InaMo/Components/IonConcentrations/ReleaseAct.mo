within InaMo.Components.IonConcentrations;
model ReleaseAct "reaction of precursor to activator"
  import InaMo.Components.Functions.Fitting.scaledExpFit;
  extends ReversibleReaction;
  CalciumSite ca;
  parameter SI.Concentration ka "concentration producing half occupation";
  input SI.Voltage v_m;
  parameter SI.Volume vol_ca "volume of calcium compartment";
equation
  rate = 203.8 * hillLangmuir(ca.amount / vol_ca, ka, 4) + scaledExpFit(v_m, x0=40e-3, sx=1000/12.5, sy=203.8);
  ca.rate = 0;
end ReleaseAct;
