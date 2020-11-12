within InaMo.Components.IonConcentrations;
model CaFlux
  CalciumSite ca
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_ca = 1;
  IonFlux flux_ca(
    redeclare connector IonSite = CalciumSite, n=n_ca, z=2
  );
equation
  connect(ca, flux_ca.ion);
end CaFlux;
