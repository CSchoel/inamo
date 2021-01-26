within InaMo.Concentrations.Interfaces;
model ElectricalIonTransport
  extends InaMo.Concentrations.Interfaces.SubstanceTransport;
  extends InaMo.Concentrations.Basic.ECAdapter(i = i_ion);
  outer SI.Current i_ion "current responsible for moving ions";
end ElectricalIonTransport;
