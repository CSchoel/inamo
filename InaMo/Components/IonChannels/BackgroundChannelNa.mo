within InaMo.Components.IonChannels;
model BackgroundChannelNa
  extends IonChannelElectric;
  extends NaFlux(vol_na=v_cyto);
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b,Na");
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_cyto;
equation
  open_ratio = 1;
end BackgroundChannelNa;
