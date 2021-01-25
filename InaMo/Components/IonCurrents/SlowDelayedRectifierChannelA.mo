within InaMo.Components.IonCurrents;
model SlowDelayedRectifierChannelA "I_K,s for atrial cell model (Lindblad 1996)"
  extends IonChannelElectric(g_max=1.5e-9);
  extends TransmembraneKFlow;
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_K,s");
  extends Modelica.Icons.UnderConstruction;
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = expFit(sx=1000/69.452, sy=1.66),
      redeclare function fbeta = expFit(sx=-1000/21.826, sy=0.3),
      off = 0.06
    ),
    redeclare function fsteady = genLogistic(x0=0.9e-3, sx=1000/13.8)
  );
equation
  open_ratio = act.n;
end SlowDelayedRectifierChannelA;
