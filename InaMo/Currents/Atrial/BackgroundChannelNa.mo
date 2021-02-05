within InaMo.Currents.Atrial;
model BackgroundChannelNa
  extends InaMo.Currents.Interfaces.IonChannelElectric;
  extends InaMo.Concentrations.Interfaces.TransmembraneNaFlow;
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b,Na");
  extends Modelica.Icons.UnderConstruction;
equation
  open_ratio = 1;
end BackgroundChannelNa;
