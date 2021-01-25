within InaMo.Components.IonCurrents;
model TransientOutwardChannel "I_to"
  extends IonChannelElectric(g_max=20e-9);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_to");
  // v_eq ~= -0.08696 V
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = scaledExpFit(x0=-30.61e-3, sx=0.09e3, sy=1.037/3.188e-3),
      redeclare function fbeta = scaledExpFit(x0=-23.84e-3, sx=-0.12e3, sy=0.396/3.188e-3),
      off = 0.596e-3
    ),
    redeclare function fsteady = genLogistic(x0=7.44e-3, sx=1000/16.4)
  );
  function inact_steady = genLogistic(x0=-33.8e-3, sx=-1000/6.12);
  GateTS inact_slow(
    redeclare function ftau = negSquaredExpFit(y_min=0.1, y_max=4+0.1, x0=-65e-3, sx=1000/sqrt(500)),
    redeclare function fsteady = inact_steady
  );
  // NOTE: the paper gives y_min as 0.12, but this is inconsistent with
  // plot S2C => we set y_min to 0.012 instead, assuming a missing zero
  GateTS inact_fast(
    redeclare function ftau = genLogistic(y_min=0.01266, y_max=4.72716+0.01266, x0=-154.5e-3, sx=-1000/23.96),
    redeclare function fsteady = inact_steady
  );
  Real inact_total = 0.55 * inact_slow.n + 0.45 * inact_fast.n;
equation
  open_ratio = act.n * inact_total;
end TransientOutwardChannel;
