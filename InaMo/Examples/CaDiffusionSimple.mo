within InaMo.Examples;
model CaDiffusionSimple
  // uses values for sub_cyto in AN cell
  InaMo.Components.IonConcentrations.DiffSimple sub_cyto(v_src=v_sub, v_dst=v_cyto, tau=0.04e-3);
  InaMo.Components.IonConcentrations.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub);
  InaMo.Components.IonConcentrations.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  parameter SI.Volume v_sub = 4.398227E-17;
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(ca_sub.c, sub_cyto.src);
  connect(sub_cyto.dst, ca_cyto.c);
end CaDiffusionSimple;
