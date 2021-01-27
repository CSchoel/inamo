within InaMo.Concentrations.Interfaces;
partial model InactiveChemicalTransport "substance transport along chemical concentration gradient"
  extends InaMo.Concentrations.Interfaces.SubstanceTransport;
  parameter SI.Volume vol_src "volume of source compartment";
  parameter SI.Volume vol_dst "volume of destination compartment";
  parameter SI.Volume vol_trans = min(vol_src, vol_dst)
    "volume of substance that is transferred between compartments over 1/coeff seconds";
  Real coeff(quantity="reaction rate coefficient", unit="1/s") "coefficient of transport";
equation
  rate = coeff * (src.amount / vol_src - dst.amount / vol_dst) * vol_trans;
end InactiveChemicalTransport;
