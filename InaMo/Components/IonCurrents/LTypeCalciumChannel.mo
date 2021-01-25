within InaMo.Components.IonCurrents;
model LTypeCalciumChannel "I_Ca,L"
  extends IonChannelElectric(g_max=18.5e-9, v_eq=62.1e-3);
  extends TransmembraneCaFlow(n_ca=1);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_Ca,L");
  outer parameter Boolean use_ach "model ACh dependence or not";
  parameter SI.Current k_ach = 0 "influence factor for acetylcholine term";
  outer parameter SI.Concentration ach;
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = fsum(
        redeclare function fa = goldman(x0=-35e-3, sx=-1000/2.5, sy=26.12*2.5),
        redeclare function fb = goldman(sx=-0.208e3, sy=78.11/0.208)
      ),
      redeclare function fbeta = goldman(x0=5e-3, sx=0.4e3, sy=10.52/0.4)
    ),
    redeclare function fsteady = genLogistic(x0=-3.2e-3, sx=1000/6.61) // parameters for AN node
  );
  function inact_steady = genLogistic(x0=-29e-3, sx=-1000/6.31);
  GateTS inact_slow(
    redeclare function ftau = gaussianOff(y_min=0.06, y_max=1.08171+0.06, x0=-40e-3, sx=1000/sqrt(138.04)),
    redeclare function fsteady = inact_steady
  );
  GateTS inact_fast(
    redeclare function ftau = gaussianOff(y_min=0.01, y_max=0.1539+0.01, x0=-40e-3, sx=1000/sqrt(185.67)),
    redeclare function fsteady = inact_steady
  );
  Real inact_total = 0.675 * inact_fast.n + 0.325 * inact_slow.n;
protected
  // TODO check order of magnitude for MM-constant
  Real ach_factor = if use_ach then (1 - k_ach * michaelisMenten(ach, 0.9e-4)) else 1;
equation
  open_ratio = act.n * inact_total * ach_factor;
end LTypeCalciumChannel;
