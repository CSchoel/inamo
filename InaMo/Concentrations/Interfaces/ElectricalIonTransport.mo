within InaMo.Components.IonConcentrations;
model ElectricalIonTransport
  extends InaMo.Interfaces.SubstanceTransport;
  extends InaMo.Components.IonConcentrations.ECAdapter(i = i_ion);
  outer SI.Current i_ion "current responsible for moving ions";
end ElectricalIonTransport;
