within InaMo.Components.IonChannels;
model SustainedInwardChannel "I_st"
  extends IonChannelElectric(G_max=0.1e-9, V_eq=37.4e-3);
  // NOTE: E_st is not given in inada 2009 => we use value from kurara 2002
  // NOTE: here the CellML model uses -37.4 mV instead of 37.4 mV
  // NOTE: Kurata 2002 uses G_max = 0.48e-9
  function reciprocalExpSum
    input Real x;
    output Real y;
    input Real x0a = 0;
    input Real x0b = 0;
    input Real sxa = 1;
    input Real sxb = 1;
    input Real sya = 1;
    input Real syb = 1;
  algorithm
    y := 1 / (sya * exp(sxa * (x - x0a)) + syb * exp(sxb * (x - x0b)));
  end reciprocalExpSum;
  // NOTE: since Kurata 2002 gives tau in ms, but inada uses s as unit, we
  // have to multiply both alpha and beta by a factor of 1000
  GateABS act(
    // NOTE: Inada 2009 uses sbx = 1000/700, but kurata 2002 uses -1000/700 which is more plausible
    redeclare function falpha = reciprocalExpSum(sya=0.15e-3, sxa=-1000/11, syb=0.2e-3, sxb=-1000/700),
    redeclare function fbeta = reciprocalExpSum(sya=16e-3, sxa=1000/8, syb=15e-3, sxb=1000/50),
    // NOTE: Kurata 2002 uses slightly different constants here, but we stick with Inada 2009
    redeclare function fsteady = generalizedLogisticFit(x0=-49.1e-3, sx=1000/8.98),
    // redeclare function fsteady = generalizedLogisticFit(x0=-57e-3, sx=1000/5),
    V = v
  );
  function freakBeta
    input Real x;
    output Real y;
    function fa = reciprocalExpSum(sya=95/0.1504e3, sxa=-1000/10, syb=50/0.1504e3, sxb=-1000/700);
    function fb = generalizedLogisticFit(y_max=0.000229e3, sx=1000/5);
  algorithm
    y := fa(x) + fb(x);
  end freakBeta;
  GateAB inact(
    redeclare function falpha = reciprocalExpSum(sya=3100/0.1504e3, sxa=1000/13, syb=700/0.1504e3, sxb=1000/70),
    redeclare function fbeta = freakBeta,
    V = v
  );
equation
  open_ratio = act.n * inact.n;
end SustainedInwardChannel;
