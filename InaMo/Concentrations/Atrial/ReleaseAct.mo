within InaMo.Concentrations.Atrial;
model ReleaseAct "reaction of precursor to activator"
  import InaMo.Functions.Fitting.expFit;
  extends ReversibleReaction;
  InaMo.Concentrations.Interfaces.CalciumSite ca;
  parameter SI.Concentration ka "concentration producing half occupation";
  input SI.Voltage v_m;
  parameter SI.Volume vol_ca "volume of calcium compartment";
equation
  rate = 203.8 * hillLangmuir(ca.amount / vol_ca, ka, 4) + expFit(v_m, x0=40e-3, sx=1000/12.5, sy=203.8);
  ca.rate = 0;
end ReleaseAct;
