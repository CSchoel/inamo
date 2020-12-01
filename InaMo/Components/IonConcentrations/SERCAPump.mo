within InaMo.Components.IonConcentrations;
model SERCAPump "SERCA kinetics for Ca2+ uptake by the SR"
  extends InaMo.Icons.InsideTopOutsideBottom;
  extends InaMo.Interfaces.SubstanceTransport;
  extends InaMo.Icons.LipidBilayerWithGap;
  extends InaMo.Icons.SERCA;
  extends InaMo.Icons.Current(current_name="SERCA");
  parameter SI.Volume vol_src "volume of source compartment";
  parameter SI.MolarFlowRate p "maximum flow rate";
  parameter SI.Concentration k "Michaelis constant";
equation
  rate = p * michaelisMenten(src.amount / vol_src, k);
end SERCAPump;
