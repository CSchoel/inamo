within InaMo.Components.IonChannels;
model TransientOutwardChannelA "I_to for atrial cell model (Lindblad 1996)"
  extends IonChannelElectric(g_max=20e-9);
  function freakTau
    function falpha = scaledExpFit(sx=1000/12, sy=386.6);
    function fbeta = scaledExpFit(sx=1000/-7.2, sy=8.011);
    input Real x;
    output Real y;
  algorithm
    y := 0.4e-3 + 1 / (falpha(x) + fbeta(x));
  end freakTau;
  GateTS act(
    redeclare function ftau = freakTau,
    redeclare function fsteady = generalizedLogisticFit(x0=-15e-3, sx=1000/5.633)
  );
  GateTS inact_fast(
    redeclare function ftau = generalizedLogisticFit(y_min=0.0204, y_max=0.189+0.0204, x0=-32.8e-3, sx=-1000/0.1),
    redeclare function fsteady = generalizedLogisticFit(x0=-28.29e-3, sx=-1000/7.06)
  );
  function customTauSlow
    function flog = generalizedLogisticFit(x0=-32.8e-3, sx=-1000/0.1, sy=5.750);
    function fnsqe = negSquaredExpFit(y_min=0.02, y_max=0.45+0.02, x0=13.54e-3, sx=-1000/13.97);
    input Real x;
    output Real y;
  algorithm
    y := flog(x) + fnsqe(x);
  end customTauSlow;
  GateTS inact_slow(
    redeclare function ftau = customTauSlow,
    redeclare function fsteady = inact_fast.fsteady
  );
  GateTS react_slow(
    redeclare function ftau = generalizedLogisticFit(y_min=0.5, y_max=7.5+0.5, x0=-23e-3, sx=1000/0.5),
    redeclare function fsteady = generalizedLogisticFit(y_min=0.666/1.666, y_max=(1+0.666)/1.666, x0=-50.67e-3, sx=-1000/27.38)
  );
  Real inact_total = (0.59 * inact_fast.n ^ 3 + 0.41 * inact_slow.n ^ 3) * (0.6 react_slow.n ^ 3 + 0.4);
equation
  open_ratio = act.n * inact_total;
end TransientOutwardChannelA;
