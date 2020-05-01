within InaMo.Components.IonChannels;
model HyperpolarizationActivatedChannel "I_f, HCN4"
  extends IonChannelElectric(G_max=1e-9, V_eq=-30e-3);
  GateTS act(
    redeclare function ftau = negSquaredExpFit(y_min=0.25, y_max=2+0.25, x0=-70e-3, sx=1000/sqrt(500)),
    redeclare function fsteady = generalizedLogisticFit(x0=-83.19e-3, sx=-1000/13.56)
  );
equation
  open_ratio = act.n;
end HyperpolarizationActivatedChannel;
