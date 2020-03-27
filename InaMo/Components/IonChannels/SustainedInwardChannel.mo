within InaMo.Components.IonChannels;
model SustainedInwardChannel "I_st"
  extends IonChannelElectric(G_max=0.1e-9, V_eq=-37.4e-3);
  // FIXME E_st is given nowhere in the paper => taken from CellML model
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
  GateABS act(
    redeclare function falpha = reciprocalExpSum(sya=0.15, sxa=-1000/11, syb=0.2, sxb=-1000/700),
    redeclare function fbeta = reciprocalExpSum(sya=16, sxa=1000/8, syb=15, sxb=1000/50),
    redeclare function fsteady = generalizedLogisticFit(x0=-49.1e-3, sx=1000/8.98),
    V = v
  );
  function freakBeta
    input Real x;
    output Real y;
    function fa = reciprocalExpSum(sya=95/0.1504, sxa=-1000/10, syb=50/0.1504, sxb=-1000/700);
    function fb = generalizedLogisticFit(y_max=0.000229, sx=1000/5);
  algorithm
    y := fa(x) + fb(x);
  end freakBeta;
  GateAB inact(
    redeclare function falpha = reciprocalExpSum(sya=3100/0.1504, sxa=1000/13, syb=700/0.1504, sxb=1000/70),
    redeclare function fbeta = freakBeta,
    V = v
  );
equation
  open_ratio = act.n * inact.n;
end SustainedInwardChannel;
