within InaMo.Components.IonChannels;
model KFlux
  IonConcentration k;
  outer parameter SI.Volume v_cyto;
  parameter Real n_k;
  IonFlux flux_k(vol=v_cyto, n=n_k);
equation
  connect(k, flux_k.ion);
end KFlux;
