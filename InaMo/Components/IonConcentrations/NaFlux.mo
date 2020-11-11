within InaMo.Components.IonConcentrations;
model NaFlux
  extends Modelica.Icons.UnderConstruction;
  SodiumSite na
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter SI.Volume vol_na;
  parameter Real n_na = 1;
  IonFlux flux_na(
    redeclare connector SubstanceSite = SodiumSite,
    vol=vol_na, n=n_na, z=1
  );
equation
  connect(na, flux_na.ion);
end NaFlux;
