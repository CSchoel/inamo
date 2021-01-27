within InaMo.Concentrations.Interfaces;
model TransmembraneNaFlow "mixin for components that transport Na+ ions from or to the extracellular compartment"
  extends InaMo.Concentrations.Interfaces.EITransportConst(
    trans(n=n_na, z=1),
    con.c_const = na_ex
  );
  SodiumSite na
    "intracellular Na+ concentration"
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_na = 1 "stoichiometric ratio of transport";
  outer parameter SI.Concentration na_ex "extracellular concentration of Na+ ions";
equation
  connect(na, trans.src);
annotation(Documentation(info="<html>
  <p>This model can be used via an extends clause in models which define an
  ion current for a variable intracellular Na+ concentration.
  The inheriting model only needs to define an
  <code>inner SI.Current i_ion</code> to match the <code>outer</code>
  definition in InaMo.Concentrations.Interfaces.ElectricalIonTransport.</p>
</html>"));
end TransmembraneNaFlow;
