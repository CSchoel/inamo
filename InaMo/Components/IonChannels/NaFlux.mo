within InaMo.Components.IonChannels;
model NaFlux
  IonConcentration na;
  outer parameter SI.Volume v_cyto;
  parameter Real n_na = 1;
  IonFlux flux_na(vol=v_cyto, n=n_na);
equation
  connect(na, flux_na.ion);
end NaFlux;
