within InaMo.Concentrations.Interfaces;
model EITransportConst "ElectricalIonTransport with constant destination concentration"
  InaMo.Concentrations.Interfaces.ElectricalIonTransport trans;
  InaMo.Concentrations.Basic.ConstantConcentration con;
equation
  connect(con.substance, trans.dst);
end EITransportConst;
