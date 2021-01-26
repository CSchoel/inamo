within InaMo.Components.IonCurrents;
model BackgroundChannelNa
  extends IonChannelElectric;
  extends TransmembraneNaFlow;
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b,Na");
  extends Modelica.Icons.UnderConstruction;
equation
  open_ratio = 1;
end BackgroundChannelNa;
