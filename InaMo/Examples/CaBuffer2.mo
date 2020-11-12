within InaMo.Examples;
model CaBuffer2 "unit test for Buffer2"
  // uses values for TMC and TMM in AN cell from InaMo
  Buffer2 tmc(c_tot=0.062, k=227.7e3, kb=0.00751e3);
  Buffer2 tmm(c_tot=0, k=2.277e3, kb=0.751e3);
  Compartment ca(c_start=0.1206e-3, vol=v_cyto);
  ConstantConcentration mg(c_const=2.5);
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(b2a.site, ca.substance;
  connect(b2b.site, mg.substance);
  connect(b2a.f_other, b2b.f_out);
  connect(b2b.f_other, b2a.f_out);
end CaBuffer2;
