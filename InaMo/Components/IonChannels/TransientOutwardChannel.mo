within InaMo.Components.IonChannels;
model TransientOutwardChannel "I_to"
  extends IonChannelElectric(G_max=20e-9, V_eq=nernst(potassium, 310));
  // V_eq ~= -0.08696 V
  parameter MobileIon potassium(c_in=140, c_ex=5.4, z=1, p=0);
  function freakTau
    function falpha = scaledExpFit(x0=-30.61e-3, sx=0.09e3, sy=1.037/3.188e-3);
    function fbeta = scaledExpFit(x0=-23.84e-3, sx=-0.12e3, sy=0.396/3.188e-3);
    input Real x;
    output Real y;
  algorithm
    y := 0.596e-3 + 1 / (falpha(x) + fbeta(x));
  end freakTau;
  GateTS act(
    redeclare function ftau = freakTau,
    redeclare function fsteady = generalizedLogisticFit(x0=7.44e-3, sx=1000/16.4),
    V = v
  );
  GateTS inact_slow(
    redeclare function ftau = negSquaredExpFit(y_min=0.1, y_max=4+0.1, x0=-65e-3, sx=1000/sqrt(500)),
    redeclare function fsteady = generalizedLogisticFit(x0=-33.8e-3, sx=-1000/6.12),
    V = v
  );
  // NOTE: the paper gives y_min as 0.12, but this is inconsistent with
  // plot S2C => we set y_min to 0.012 instead, assuming a missing zero
  GateTS inact_fast(
    redeclare function ftau = generalizedLogisticFit(y_min=0.01266, y_max=4.72716+0.01266, x0=-154.5e-3, sx=-1000/23.96),
    redeclare function fsteady = inact_slow.fsteady,
    V = v
  );
  Real inact_total = 0.55 * inact_slow.n + 0.45 * inact_fast.n;
equation
  open_ratio = act.n * inact_total;
end TransientOutwardChannel;
