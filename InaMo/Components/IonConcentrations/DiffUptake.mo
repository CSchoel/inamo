within InaMo.Components.IonConcentrations;
model DiffUptake "Ca2+ uptake by SR, see Hilgeman 1987"
  extends DiffusionVol;
  extends Modelica.Icons.UnderConstruction;
  parameter Real k_ca_cyto "rate constant for Ca2+ binding of calcium ATPase in cytosol";
  parameter Real k_ca_sr "rate constant for Ca2+ binding of calcium ATPase in SR";
  parameter Real k_tr_empty "rate constant for translocation of empty calcium ATPase from cytosol to SR";
  parameter SI.Current i_max "maximum uptake current";
protected
  SI.Current i;
equation
  i = i_max * (src.c / k_ca_cyto - k_tr_empty ^ 2 * dst.c / k_ca_sr)
    / (src.c + k_ca_cyto) / k_ca_cyto + k_tr_empty * (dst.c + k_ca_sr) / k_ca_sr;
  j = i / (2 * Modelica.Constants.F * v_min);
end DiffUptake;
