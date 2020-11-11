within InaMo.Components.IonCurrents;
model BackgroundChannelCa
  extends IonChannelElectric;
  extends CaFlux;
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b,Ca");
  extends Modelica.Icons.UnderConstruction;
equation
  open_ratio = 1;
end BackgroundChannelCa;
