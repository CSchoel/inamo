within InaMo.Components.IonChannels;
model HyperpolarizationActivatedChannel "I_f, HCN4"
  extends IonChannelElectric(G_max=1, V_eq=-30);
  GateTS activation(
    redeclare function ftau = squaredXGenLogFit(y_min=0.25, y_max=2+0.25, x0=-70e-3, sx=1000/sqrt(500), d_off=0),
    redeclare function fsteady = generalizedLogisticFit(x0=-83.19e-3, sx=-1000/13.56),
    V = v
  );
equation
  open_ratio = activation.n;
end HyperpolarizationActivatedChannel;
