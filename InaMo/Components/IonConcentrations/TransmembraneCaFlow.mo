within InaMo.Components.IonConcentrations;
model TransmembraneCaFlow "mixin for components that transport Ca2+ ions from or to the extracellular compartment"
  CalciumSite ca
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_ca = 1;
  IonFlux flux_ca(
    redeclare connector IonSite = CalciumSite, n=n_ca, z=2
  );
equation
  connect(ca, flux_ca.ion);
end TransmembraneCaFlow;
