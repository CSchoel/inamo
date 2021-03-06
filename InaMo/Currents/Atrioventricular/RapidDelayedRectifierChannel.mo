within InaMo.Currents.Atrioventricular;
model RapidDelayedRectifierChannel "Rapid delayed rectifier potassium channel (I_K,r)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max=1.5e-9);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_K,r");
  function act_steady = genLogistic(x0=-10.22e-3, sx=1000/8.5) "function for steady state of activation gates";
  GateTS act_fast(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = expFit(sx=0.0398e3, sy=17),
      redeclare function fbeta = expFit(sx=-0.051e3, sy=0.211)
    ),
    redeclare function fsteady = act_steady
  ) "voltage-dependent fast activation";
  GateTS act_slow(
    redeclare function ftau = gaussianAmp(y_min=0.33581, y_max=0.90673+0.33581, x0=-10e-3, sigma=sqrt(988.05/2)/1000),
    redeclare function fsteady = act_steady
  ) "voltage-dependent slow activation";
  GateTS inact(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = expFit(sx=0.00942e3, sy=603.6),
      redeclare function fbeta = expFit(sx=-0.0183e3, sy=92.01)
    ),
    redeclare function fsteady = fprod(
      redeclare function fa = genLogistic(x0=-4.9e-3, sx=-1000/15.14),
      redeclare function fb = gaussianAmp(y_min=1, y_max=-0.3 + 1, sigma=sqrt(500/2)/1000)
    )
  ) "voltage-dependent inactivation";
  Real act_total = 0.9 * act_fast.n + 0.1 * act_slow.n "total activation due to slow and fast activation terms";
equation
  open_ratio = act_total * inact.n;
end RapidDelayedRectifierChannel;
