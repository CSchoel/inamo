within InaMo.Components.IonChannels;
model BackgroundChannel
  extends IonChannelElectric(current_name="I_b");
  extends InaMo.Icons.OpenChannel;
equation
  open_ratio = 1;
end BackgroundChannel;
