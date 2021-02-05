within InaMo.Currents.Atrial;
model BackgroundChannelCa
  extends InaMo.Currents.Interfaces.IonChannelElectric;
  extends InaMo.Concentrations.Interfaces.TransmembraneCaFlow;
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b,Ca");
  extends Modelica.Icons.UnderConstruction;
equation
  open_ratio = 1;
end BackgroundChannelCa;
