within InaMo.Examples;
model CaDiffusionHL
  // uses values for jsr_sub in AN cell
  DiffHL jsr_sub(v_src=v_sub, v_dst=v_cyto, p=0.005e3,k=0.0006);
  Compartment ca_nsr(c_start=1.068, vol=v_nsr);
  Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  parameter SI.Volume v_nsr = 5.10194319E-17;
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(ca_sub.c, sub_cyto.src);
  connect(sub_cyto.dst, ca_cyto.c);
end CaDiffusionHL;
