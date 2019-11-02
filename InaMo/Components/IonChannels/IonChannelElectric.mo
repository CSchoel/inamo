within InaMo.Components.IonChannels;
partial model IonChannelElectric "ion channel based on electrical analog (voltage source + conductor)"
  extends GatedIonChannel;
  import Modelica.SIunits.*;
  Conductance G = i_open * G_max "ion conductance";
  parameter Conductance G_max "maximum conductance";
equation
  i_open = G_max * (v - V_eq);
end IonChannelElectric;
