within InaMo.Components.IonChannels;
model CaFlux
  IonConcentration ca;
  outer parameter SI.Volume v_ca;
  parameter Real n_ca;
  IonFlux flux_ca(vol=v_ca, n=n_ca);
equation
  connect(ca, flux_ca.ion);
end CaFlux;
