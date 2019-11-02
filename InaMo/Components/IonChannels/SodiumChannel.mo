within InaMo.Components.IonChannels;
model SodiumChannel "sodium channel as used by inada2009 and lindblad1997"
  extends IonChannelGHK;
  // Note: mV -> V by setting V_off /= 1000 and sV *= 1000
  // Note: time scale is already in seconds => no futher changes required
  GateAB activation(
    redeclare function falpha = goldmanFit(V_off=0.0444, sdn=460*12.673, sV=-1000/12.673),
    redeclare function fbeta = scaledExpFit(x0=0.0444, sx=-1000/12.673, sy=-18400*12.673),
    V=v
  );
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  // Note: time scale is already in seconds => no further changes required
  GateABT inact_type1(
    redeclare function falpha = falpha_i,
    redeclare function fbeta = fbeta_i,
    redeclare function ftau = generalizedLogisticFit(y_min=0.00035, y_max=0.03+0.00035, x0=-0.040, sx=-1000/6.0, se=1),
    V=v
  );
  GateABT inact_type2(
    redeclare function falpha = falpha_i,
    redeclare function fbeta = fbeta_i,
    redeclare function ftau = generalizedLogisticFit(y_min=0.00295, y_max=0.12+0.00295, x0=-0.060, sx=-1000/2.0, se=1),
    V=v
  );
  Real inact_total = 0.635 * inact_type1.n + 0.365 * inact_type2.n;
protected
  function falpha_i = scaledExpFit(x0=0.0669, sx=-1000/5.57, sy=44.9);
  function fbeta_i = generalizedLogisticFit(y_min=0, y_max=1491, x0=-0.0946, sx=1000/12.9, se=323.3);
equation
  open_ratio = activation.n^3 * inact_total;
end SodiumChannel;
