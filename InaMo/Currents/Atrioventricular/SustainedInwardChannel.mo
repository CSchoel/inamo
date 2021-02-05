within InaMo.Currents.Atrioventricular;
model SustainedInwardChannel "sustained inward current (I_st)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max=0.1e-9, v_eq=37.4e-3);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_st");
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = pseudoABTau(
        redeclare function falpha = expFit(sy=0.15e-3, sx=-1000/11),
        redeclare function fbeta = expFit(sy=0.2e-3, sx=-1000/700)
      ),
      redeclare function fbeta = pseudoABTau(
        redeclare function falpha = expFit(sy=16e-3, sx=1000/8),
        redeclare function fbeta = expFit(sy=15e-3, sx=1000/50)
      )
    ),
    redeclare function fsteady = genLogistic(x0=-49.1e-3, sx=1000/8.98)
  ) "voltage-dependent activation";
  GateAB inact(
    redeclare function falpha = pseudoABTau(
      redeclare function falpha = expFit(sy=3100/0.1504e3, sx=1000/13),
      redeclare function fbeta = expFit(sy=700/0.1504e3, sx=1000/70)
    ),
    redeclare function fbeta = fsum(
      redeclare function fa = pseudoABTau(
        redeclare function falpha = expFit(sy=95/0.1504e3, sx=-1000/10),
        redeclare function fbeta = expFit(sy=50/0.1504e3, sx=-1000/700)
      ),
      redeclare function fb = genLogistic(y_max=0.000229e3, sx=1000/5)
    )
  ) "voltage-dependent inactivation";
equation
  open_ratio = act.n * inact.n;
annotation(Documentation(info="<html>
  <p>This model was originally developed by Kurata et al. (Kurata 2002).
  It was slightly changed by Inada et al. by adjusting parameter settings and
  the equation for act.fsteady.</p>
  <p>NOTE: v_eq is not given in Inada 2009 (where it is called E_st).
  We therefore assume the value given in Kurata 2002.
  The CellML implementation of Inada 2009 uses -37.4 mV instead of 37.4 mV,
  but this seems to be an error.</p>
  <p>NOTE: Since Kurata 2002 gives tau in ms, but inada uses s as unit, we
  needed to multiply both alpha and beta for act and inact by a factor of
  1000.</p>
  <p>NOTE: Inada 2009 uses act.ftau.falpha.fbeta.sx = 1000/700, but Kurata
  2002 uses -1000/700, which is more plausible.
  We therefore use the value from Kurata 2002.</p>
</html>"));
end SustainedInwardChannel;
