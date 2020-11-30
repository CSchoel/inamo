within InaMo.Components.IonConcentrations;
partial model InactiveChemicalTransport "substance transport along chemical concentration gradient"
  extends InaMo.Interfaces.SubstanceTransport;
  parameter SI.Volume vol_src "volume of source compartment";
  parameter SI.Volume vol_dst "volume of destination compartment";
  parameter SI.Volume vol_trans = min(vol_src, vol_dst)
    "volume of substance that is transferred between compartments over tau seconds";
  Real tau "time constant of transport";
equation
  rate = (src.amount / vol_src - dst.amount / vol_dst) * vol_trans / tau;
end InactiveChemicalTransport;
