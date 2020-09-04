within InaMo.Components.IonChannels;
model BackgroundChannelCa
  extends IonChannelElectric(current_name="I_b,Ca");
  extends CaFlux(vol_ca=v_ca);
  extends InaMo.Icons.OpenChannel;
  outer parameter SI.Volume v_ca;
equation
  open_ratio = 1;
end BackgroundChannelCa;
