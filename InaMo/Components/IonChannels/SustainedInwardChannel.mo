within InaMo.Components.IonChannels;
model SustainedInwardChannel "I_st"
  extends IonChannelElectric(g_max=0.1e-9, v_eq=37.4e-3);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_st");
  // NOTE: E_st is not given in inada 2009 => we use value from kurara 2002
  // NOTE: here the CellML model uses -37.4 mV instead of 37.4 mV
  // NOTE: Kurata 2002 uses g_max = 0.48e-9
  // NOTE: since Kurata 2002 gives tau in ms, but inada uses s as unit, we
  // have to multiply both alpha and beta by a factor of 1000
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = pseudoABTau(
        redeclare function falpha = scaledExpFit(sy=0.15e-3, sx=-1000/11),
        // NOTE: Inada 2009 uses sbx = 1000/700, but kurata 2002 uses -1000/700 which is more plausible
        redeclare function fbeta = scaledExpFit(sy=0.2e-3, sx=-1000/700)
      ),
      redeclare function fbeta = pseudoABTau(
        redeclare function falpha = scaledExpFit(sy=16e-3, sx=1000/8),
        redeclare function fbeta = scaledExpFit(sy=15e-3, sx=1000/50)
      )
    ),
    // NOTE: Kurata 2002 uses slightly different constants here, but we stick with Inada 2009
    redeclare function fsteady = generalizedLogisticFit(x0=-49.1e-3, sx=1000/8.98)
    // redeclare function fsteady = generalizedLogisticFit(x0=-57e-3, sx=1000/5)
  );
  GateAB inact(
    redeclare function falpha = reciprocalExpSum(sya=3100/0.1504e3, sxa=1000/13, syb=700/0.1504e3, sxb=1000/70),
    redeclare function fbeta = fsum(
      redeclare function fa = reciprocalExpSum(sya=95/0.1504e3, sxa=-1000/10, syb=50/0.1504e3, sxb=-1000/700),
      redeclare function fb = generalizedLogisticFit(y_max=0.000229e3, sx=1000/5)
    )
  );
equation
  open_ratio = act.n * inact.n;
end SustainedInwardChannel;
