within InaMo.Components.IonChannels;
model DelayedRectifierChannel "I_K,r"
  extends IonChannelElectric(G_max=1.5e-9, V_eq=-81.9e-3);
  GateABS act_fast(
    redeclare function falpha = scaledExpFit(sx=0.0398e3, sy=17),
    redeclare function fbeta = scaledExpFit(sx=-0.051e3, sy=0.211),
    redeclare function fsteady = generalizedLogisticFit(x0=-10.22e-3, sx=1000/8.5),
    V = v
  );
  GateTS act_slow(
    redeclare function ftau = generalizedLogisticFit(y_min=0.33581, y_max=0.90673+0.33581, x0=-10e-3, sx=-100/sqrt(988.05), nu=0.5, d_off=0),
    redeclare function fsteady = act_fast.fsteady,
    V = v
  );
  function freakSteady
    input Real x;
    output Real y;
    function fnum = generalizedLogisticFit(x0=-4.9e-3, sx=-1000/15.14);
    function fden = generalizedLogisticFit(se=-0.3, sx=1000/sqrt(500), nu=0.5);
  algorithm
    y := fnum(x) / fden(x);
  end freakSteady;
  GateABS inact(
    redeclare function falpha = scaledExpFit,
    redeclare function fbeta = scaledExpFit,
    redeclare function fsteady = freakSteady,
    V = v
  );
  Real act_total = 0.9 * act_fast.n + 0.1 * act_slow.n;
equation
  open_ratio = act_total * inact.n;
end DelayedRectifierChannel;
