within InaMo.Concentrations.Interfaces;
model TransmembraneCaFlow "mixin for components that transport Ca2+ ions from or to the extracellular compartment"
  extends InaMo.Concentrations.Interfaces.EITransportConst(
    trans(n=n_ca, z=2),
    con.c_const = ca_ex
  );
  CalciumSite ca
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_ca = 1;
  outer parameter SI.Concentration ca_ex "extracellular concentration of Ca2+ ions";
equation
  connect(ca, trans.src);
end TransmembraneCaFlow;