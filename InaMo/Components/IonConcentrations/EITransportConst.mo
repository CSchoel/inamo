within InaMo.Components.IonConcentrations;
model EITransportConst "ElectricalIonTransport with constant destination concentration"
  InaMo.Components.IonConcentrations.ElectricalIonTransport trans;
  InaMo.Components.IonConcentrations.ConstantConcentration const;
equation
  connect(const.substance, trans.dst);
end EITransportConst;
