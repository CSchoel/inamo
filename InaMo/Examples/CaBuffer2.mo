within InaMo.Examples;
model CaBuffer2 "unit test for Buffer2"
  // uses values for TMC and TMM in AN cell from InaMo
  InaMo.Components.IonConcentrations.Buffer2 tmc(c_tot=0.062, k=227.7e3, kb=0.00751e3);
  InaMo.Components.IonConcentrations.Buffer2 tmm(c_tot=0, k=2.277e3, kb=0.751e3);
  InaMo.Components.IonConcentrations.Compartment ca(c_start=0.1206e-3, vol=v_cyto);
  InaMo.Components.IonConcentrations.ConstantConcentration mg(c_const=2.5);
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(tmc.c, ca.c);
  connect(tmm.c, mg.c);
  connect(tmc.f_other, tmm.f_out);
  connect(tmm.f_other, tmc.f_out);
end CaBuffer2;
