within InaMo.Currents.Atrioventricular;
model HyperpolarizationActivatedChannel "hyperpolarization-activated channel responsible for \"funny\" current (I_f, HCN4)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max=1e-9, v_eq=-30e-3);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Current(current_name="I_f");
  outer parameter Boolean use_ach;
  outer parameter SI.Concentration ach;
  parameter Real act_shift = if use_ach then -7.2 * hillLangmuir(ach, 1.26e-5, 0.69) else 0;
  GateTSShift act(
    redeclare function ftau = gaussianAmp(y_min=0.25, y_max=2+0.25, x0=-70e-3, sigma=sqrt(500/2)/1000),
    redeclare function fsteady = genLogistic(x0=-83.19e-3, sx=-1000/13.56),
    shift=act_shift
  );
equation
  open_ratio = act.n;
end HyperpolarizationActivatedChannel;
