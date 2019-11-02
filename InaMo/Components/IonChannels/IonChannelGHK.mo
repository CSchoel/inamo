within InaMo.Components.IonChannels;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  parameter SI.Permeability P "Na+ permeability for sodium current";
  input SI.Concentration C_ex "extracellular Na+ concentration";
  TemperatureInput T "membrane temperature";
protected
  Real tc = Modelica.Constants.F / (Modelica.Constants.R * T);
equation
  i_open = P * C_ex * Modelica.Constants.F * tc * (exp((v - V_eq) * tc) - 1) / (exp(v * tc) - 1);
end IonChannelGHK;
