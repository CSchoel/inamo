within InaMo.Components.IonChannels;
model RapidDelayedRectifierChannel "I_K,r"
  extends IonChannelElectric(G_max=1.5e-9, V_eq=nernst(potassium, 310));
  parameter MobileIon potassium(c_in=140, c_ex=5.4, z=1, p=0);
  GateABS act_fast(
    redeclare function falpha = scaledExpFit(sx=0.0398e3, sy=17),
    redeclare function fbeta = scaledExpFit(sx=-0.051e3, sy=0.211),
    redeclare function fsteady = generalizedLogisticFit(x0=-10.22e-3, sx=1000/8.5),
    V = v
  );
  GateTS act_slow(
    redeclare function ftau = negSquaredExpFit(y_min=0.33581, y_max=0.90673+0.33581, x0=-10e-3, sx=1000/sqrt(988.05)),
    redeclare function fsteady = act_fast.fsteady,
    V = v
  );
  function freakSteady
    input Real x;
    output Real y;
    function fnum = generalizedLogisticFit(x0=-4.9e-3, sx=-1000/15.14);
    function fden = negSquaredExpFit(y_min=1, y_max=-0.3 + 1, sx=1000/sqrt(500));
  algorithm
    y := fnum(x) / fden(x);
  end freakSteady;
  GateABS inact(
    redeclare function falpha = scaledExpFit(sx=-0.0183e3, sy=92.01),
    redeclare function fbeta = scaledExpFit(sx=0.00942e3, sy=603.6),
    redeclare function fsteady = freakSteady,
    V = v
  );
  Real act_total = 0.9 * act_fast.n + 0.1 * act_slow.n;
equation
  open_ratio = act_total * inact.n;
end RapidDelayedRectifierChannel;
