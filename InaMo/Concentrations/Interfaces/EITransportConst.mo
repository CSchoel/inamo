within InaMo.Concentrations.Interfaces;
model EITransportConst "ElectricalIonTransport with constant destination concentration"
  InaMo.Components.IonConcentrations.ElectricalIonTransport trans;
  InaMo.Components.IonConcentrations.ConstantConcentration con;
equation
  connect(con.substance, trans.dst);
end EITransportConst;
