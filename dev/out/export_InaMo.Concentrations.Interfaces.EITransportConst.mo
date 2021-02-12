model EITransportConst "ElectricalIonTransport with constant destination concentration"
  InaMo.Concentrations.Interfaces.ElectricalIonTransport trans;
  InaMo.Concentrations.Basic.ConstantConcentration con;
equation
  connect(con.substance, trans.dst);
  annotation(
    Documentation(info = "<html>
  <p>This model allows to define transmembrane currents, which only change
  the intracellular concentration but keep the extracellular concentration
  constant.</p>
  <p>It should not be used on its own.
  Instead, InaMo.Concentrations.Interfaces.TransmembraneCaFlow and similar
  models should be used in order to clearly define the type of ion that is
  transported.</p>
</html>"));
end EITransportConst;