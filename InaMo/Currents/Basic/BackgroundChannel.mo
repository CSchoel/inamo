within InaMo.Currents.Basic;
model BackgroundChannel "generic background channel, which is always fully open"
  extends IonChannelElectric;
  extends InaMo.Icons.OpenChannel;
  extends InaMo.Icons.Current(current_name="I_b");
equation
  open_ratio = 1;
end BackgroundChannel;
