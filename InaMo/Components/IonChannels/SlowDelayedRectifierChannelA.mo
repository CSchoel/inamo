within InaMo.Components.IonChannels;
model SlowDelayedRectifierChannelA "I_K,s for atrial cell model (Lindblad 1996)"
  extends IonChannelElectric(g_max=1.5e-9);
  extends KFlux(vol_k=v_cyto);
  outer parameter SI.Volume v_cyto;
  GateTS act(
    redeclare function ftau = pseudoAbTau(
      redeclare function falpha = scaledExpFit(sx=1000/69.452, sy=1.66),
      redeclare function fbeta = scaledExpFit(sx=-1000/21.826, sy=0.3),
      off = 0.06
    ),
    redeclare function fsteady = generalizedLogisticFit(x0=0.9e-3, sx=1000/13.8)
  );
equation
  open_ratio = act.n;
end SlowDelayedRectifierChannelA;
