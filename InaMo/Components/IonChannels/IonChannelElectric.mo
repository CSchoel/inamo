within InaMo.Components.IonChannels;
partial model IonChannelElectric "ion channel based on electrical analog (voltage source + conductor)"
  extends GatedIonChannel;
  parameter SI.ElectricPotential V_eq "equilibrium potential";
  parameter SI.Conductance G_max "maximum conductance";
  SI.Conductance G = open_ratio * G_max "ion conductance";
equation
  i_open = G_max * (v - V_eq);
end IonChannelElectric;
