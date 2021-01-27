within InaMo.Concentrations.Interfaces;
model TransmembraneKFlow "mixin for components that transport K+ ions from or to the extracellular compartment"
  extends InaMo.Concentrations.Interfaces.EITransportConst(
    trans(n=n_k, z=1),
    con.c_const = k_ex
  );
  PotassiumSite k
    "intracellular K+ concentration"
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_k = 1 "stoichiometric ratio of transport";
  outer parameter SI.Concentration k_ex "extracellular concentration of K+ ions";
equation
  connect(k, trans.src);
annotation(Documentation(info="<html>
  <p>This model can be used via an extends clause in models which define an
  ion current for a variable intracellular K+ concentration.
  The inheriting model only needs to define an
  <code>inner SI.Current i_ion</code> to match the <code>outer</code>
  definition in InaMo.Concentrations.Interfaces.ElectricalIonTransport.</p>
</html>"));
end TransmembraneKFlow;
