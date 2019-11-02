within InaMo.Components.IonChannels;
partial model IonChannelElectric "ion channel based on electrical analog (voltage source + conductor)"
  extends GatedIonChannel;
  SI.Conductance G = open_ratio * G_max "ion conductance";
  parameter SI.Conductance G_max "maximum conductance";
equation
  i_open = G_max * (v - V_eq);
end IonChannelElectric;
