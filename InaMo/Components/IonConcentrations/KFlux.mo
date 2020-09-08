within InaMo.Components.IonConcentrations;
model KFlux
  extends Modelica.Icons.UnderConstruction;
  PotassiumConcentration k
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter SI.Volume vol_k;
  parameter Real n_k = 1;
  IonFlux flux_k(
    redeclare connector ConcentrationType = PotassiumConcentration,
    vol=vol_k, n=n_k, z=1
  );
equation
  connect(k, flux_k.ion);
end KFlux;
