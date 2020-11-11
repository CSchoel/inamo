within InaMo.Components.IonConcentrations;
model CaFlux
  CalciumSite ca
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter SI.Volume vol_ca;
  parameter Real n_ca = 1;
  IonFlux flux_ca(
    redeclare connector SubstanceSite = CalciumSite,
    vol=vol_ca, n=n_ca, z=2
  );
equation
  connect(ca, flux_ca.ion);
end CaFlux;
