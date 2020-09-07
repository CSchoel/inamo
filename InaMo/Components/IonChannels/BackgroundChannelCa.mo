within InaMo.Components.IonChannels;
model BackgroundChannelCa
  extends IonChannelElectric;
  extends CaFlux(vol_ca=v_ca);
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b,Ca");
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_ca;
equation
  open_ratio = 1;
end BackgroundChannelCa;
