within InaMo.Components.IonChannels;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  import Modelica.SIunits.*;
  parameter Permeability P "Na+ permeability for sodium current";
  input Concentration C_ex "extracellular Na+ concentration";
  TemperatureInput T "membrane temperature";
protected
  Real tc = Modelica.Constants.F / (Modelica.Constants.R * T);
equation
  I_open = P * C_ex * Modelica.Constants.F * tc * (exp((v - V_eq) * tc) - 1) / (exp(v * tc) - 1);
end IonChannelGHK;
