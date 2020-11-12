within InaMo.Examples;
model CaBuffer "unit test for buffer model"
  // uses values for TC in AN cell from InaMo
  InaMo.Components.IonConcentrations.Buffer tc(c_tot=0.031, k=88.8e3, kb=0.446e3);
  InaMo.Components.IonConcentrations.Compartment ca_cyto(c_start=0.1206e-3, vol=1.9792021E-15);
equation
  connect(tc.c, ca_cyto.c);
end CaBuffer;
