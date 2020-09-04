within InaMo.Components.IonChannels;
model BackgroundChannelNa
  extends IonChannelElectric(current_name="I_b,Na");
  extends NaFlux(vol_na=v_cyto);
  extends InaMo.Icons.OpenChannel;
  outer parameter SI.Volume v_cyto;
equation
  open_ratio = 1;
end BackgroundChannelNa;
