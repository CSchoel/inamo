within InaMo.Components.IonChannels;
model BackgroundChannelCa
  extends IonChannelElectric;
  extends CaFlux(vol_ca=v_ca);
  outer parameter SI.Volume v_ca;
equation
  open_ratio = 1;
end BackgroundChannelCa;