within InaMo.Components.IonChannels;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  MobileIon ion "ion for which this channel is (exclusively) selective";
  outer SI.Temperature T "membrane temperature";
equation
  i_open = ghkFlux(v, T, ion) * unitArea "multiply with unit area to preserve correct units";
end IonChannelGHK;
