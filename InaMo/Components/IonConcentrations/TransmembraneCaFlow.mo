within InaMo.Components.IonConcentrations;
model TransmembraneCaFlow "mixin for components that transport Ca2+ ions from or to the extracellular compartment"
  extends InaMo.Components.IonConcentrations.EITransportConst(
    trans(n=n_ca, z=2)
  );
  CalciumSite ca
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_ca = 1;
equation
  connect(ca, trans.src);
end TransmembraneCaFlow;
