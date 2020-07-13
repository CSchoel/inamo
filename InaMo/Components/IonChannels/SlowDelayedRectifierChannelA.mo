within InaMo.Components.IonChannels;
model SlowDelayedRectifierChannelA "I_K,s for atrial cell model (Lindblad 1996)"
  extends IonChannelElectric(g_max=1.5e-9);
  function freakTau
    function falpha = scaledExpFit(sx=1000/69.452, sy=1.66);
    function fbeta = scaledExpFit(sx=-1000/21.826, sy=0.3);
    input Real x;
    output Real y;
  algorithm
    y := 1 / (falpha(x) + fbeta(x)) + 0.06;
  end freakTau;
  GateTS act(
    redeclare function ftau = freakTau,
    redeclare function fsteady = generalizedLogisticFit(x0=0.9e-3, sx=1000/13.8)
  );
equation
  open_ratio = act.n;
end SlowDelayedRectifierChannelA;
