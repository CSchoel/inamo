within InaMo.Components.IonChannels;
model TTypeCalciumChannelA "I_Ca,L for atrial model (Lindblad 1996)"
  extends IonChannelElectric(g_max=18.5e-9, v_eq=62.1e-3);
  GateAB act(
    redeclare function falpha = scaledExpFit(x0=-23e-3, sx=1000/30, sy=674.173),
    redeclare function fbeta = scaledExpFit(x0=-23e-3, sx=-1000/30, sy=674.173)
  );
  GateAB inact(
    redeclare function falpha = scaledExpFit(x0=-75e-3, sx=-1000/83.333, sy=9.637),
    redeclare function fbeta = scaledExpFit(x0=-75e-3, sx=1000/15.385, sy=9.637)
  );
equation
  open_ratio = act.n * inact.n;
end TTypeCalciumChannelA;
