model ElectricalIonTransport "transport of ions across a boundary due to a current"
  extends InaMo.Concentrations.Interfaces.SubstanceTransport;
  extends InaMo.Concentrations.Basic.ECAdapter(i = i_ion);
  outer SI.Current i_ion "current responsible for moving ions";
end ElectricalIonTransport;