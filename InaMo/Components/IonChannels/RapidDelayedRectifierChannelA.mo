within InaMo.Components.IonChannels;
model RapidDelayedRectifierChannelA "I_K,r for atrial cell model (Lindblad 1996)"
  extends IonChannelElectric(g_max=1.5e-9, current_name="I_K,r");
  extends KFlux(vol_k=v_cyto);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  outer parameter SI.Volume v_cyto;
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = scaledExpFit(sx=1000/25.371, sy=9),
      redeclare function fbeta = scaledExpFit(sx=-1000/13.026, sy=1.3)
    ),
    redeclare function fsteady = generalizedLogisticFit(x0=-5.1e-3, sx=1000/7.4)
  );
  // FIXME alpha and beta seem to be swapped in paper (not that it matters mathematically)
  GateAB inact(
    redeclare function falpha = scaledExpFit(sx=1000/106.157, sy=656),
    redeclare function fbeta = scaledExpFit(sx=-1000/54.645, sy=100)
  );
equation
  open_ratio = act.n * inact.n;
end RapidDelayedRectifierChannelA;
