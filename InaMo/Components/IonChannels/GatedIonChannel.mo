within InaMo.Components.IonChannels;
partial model GatedIonChannel "ion channel with voltage and temperature dependent gates"
  extends IonChannel;
  TemperatureInput T "membrane temperature to determine reaction coefficient";
end GatedIonChannel;
