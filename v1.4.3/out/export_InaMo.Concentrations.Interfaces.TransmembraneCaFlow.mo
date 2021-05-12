model TransmembraneCaFlow "mixin for components that transport Ca2+ ions from or to the extracellular compartment"
  extends InaMo.Concentrations.Interfaces.EITransportConst(trans(n = n_ca, z = 2), con.c_const = ca_ex);
  SubstanceSite ca "intracellular Ca2+ concentration" annotation(
    Placement(visible = true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_ca = 1 "stoichiometric ratio of transport";
  outer parameter SI.Concentration ca_ex "extracellular concentration of Ca2+ ions";
equation
  connect(ca, trans.src);
  annotation(
    Documentation(info = "<html>
  <p>This model can be used via an extends clause in models which define an
  ion current for a variable intracellular Ca2+ concentration.
  The inheriting model only needs to define an
  <code>inner SI.Current i_ion</code> to match the <code>outer</code>
  definition in InaMo.Concentrations.Interfaces.ElectricalIonTransport.</p>
</html>"));
end TransmembraneCaFlow;