within InaMo.Components.IonChannels;
model HyperpolarizationActivatedChannel "I_f, HCN4"
  extends IonChannelElectric(g_max=1e-9, v_eq=-30e-3);
  parameter Boolean use_ach = false;
  outer parameter SI.Concentration ach if use_ach;
  // TODO check if order of magnitude of MM-constant is correct
  Real act_shift = if use_ach then -7.2 * michaelisMenten(ach^0.69, 1e3 * 1.26e-8^0.69) else 0;
  GateTSShift act(
    redeclare function ftau = negSquaredExpFit(y_min=0.25, y_max=2+0.25, x0=-70e-3, sx=1000/sqrt(500)),
    redeclare function fsteady = generalizedLogisticFit(x0=-83.19e-3, sx=-1000/13.56),
    shift=act_shift
  );
equation
  open_ratio = act.n;
end HyperpolarizationActivatedChannel;
