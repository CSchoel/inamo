within InaMo.Components.IonChannels;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  MobileIon ion "ion for which this channel is (exclusively) selective";
  TemperatureInput T "membrane temperature";
equation
  i_open = ghkFlux(v, T, ion);
end IonChannelGHK;
