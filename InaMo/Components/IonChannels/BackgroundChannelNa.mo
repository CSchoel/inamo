within InaMo.Components.IonChannels;
model BackgroundChannelNa
  extends IonChannelElectric;
  extends NaFlux(vol_na=v_cyto);
  outer parameter SI.Volume v_cyto;
equation
  open_ratio = 1;
end BackgroundChannelNa;