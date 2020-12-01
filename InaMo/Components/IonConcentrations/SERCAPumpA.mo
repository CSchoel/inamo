within InaMo.Components.IonConcentrations;
model SERCAPumpA "Ca2+ uptake by SR, see Hilgeman 1987"
  // TODO this model should be subdivided into smaller modules for each reaction
  extends InaMo.Interfaces.SubstanceTransport;
  extends InaMo.Icons.InsideTopOutsideBottom;
  extends InaMo.Components.IonConcentrations.ECAdapter(i=i_ca, z=2, n=1);
  extends Modelica.Icons.UnderConstruction;
  parameter Real k_ca_cyto "rate constant for Ca2+ binding of calcium ATPase in cytosol";
  parameter Real k_ca_sr "rate constant for Ca2+ binding of calcium ATPase in SR";
  parameter Real k_tr_empty "rate constant for translocation of empty calcium ATPase from cytosol to SR";
  parameter SI.Current i_max "maximum uptake current";
  parameter SI.Volume vol_src "volume of source compartment";
  parameter SI.Volume vol_dst "volume of destination compartment";
protected
  SI.Current i_ca;
equation
  i_ca = i_max * (src.amount / vol_src / k_ca_cyto - k_tr_empty ^ 2 * dst.amount / vol_dst / k_ca_sr)
    / (src.amount / vol_src + k_ca_cyto) / k_ca_cyto + k_tr_empty * (dst.amount / vol_dst + k_ca_sr) / k_ca_sr;
end SERCAPumpA;
