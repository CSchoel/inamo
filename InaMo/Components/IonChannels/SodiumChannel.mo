within InaMo.Components.IonChannels;
model SodiumChannel "sodium channel as used by inada2009 and lindblad1997"
  extends IonChannelGHK(
    ion_in=if na_const then na_in else 1, ion_ex=na_ex, ion_p=na_p, ion_z=1,
    current_name="I_Na"
  );
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  outer parameter SI.Concentration na_in if na_const;
  parameter Boolean na_const = true;
  outer parameter SI.Concentration na_ex;
  outer parameter PermeabilityFM na_p;
  // Note: mV -> V by setting x0 /= 1000 and sx *= 1000
  // Note: time scale is already in seconds => no futher changes required
  GateAB act(
    redeclare function falpha = goldmanFit(x0=-0.0444, sx=-1000/12.673, sy=460*12.673),
    redeclare function fbeta = scaledExpFit(x0=-0.0444, sx=-1000/12.673, sy=18400)
  );
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  // Note: time scale is already in seconds => no further changes required
  GateTS inact_fast(
    redeclare function fsteady = pseudoABSteady(
      redeclare function falpha = scaledExpFit(x0=-0.0669, sx=-1000/5.57, sy=44.9),
      redeclare function fbeta = generalizedLogisticFit(y_min=0, y_max=1491, x0=-0.0946, sx=1000/12.9, se=323.3)
    ),
    redeclare function ftau = generalizedLogisticFit(y_min=0.00035, y_max=0.03+0.00035, x0=-0.040, sx=-1000/6.0, se=1)
  ) "inactivation gate for fast sodium channels (type1/h1)";
  GateTS inact_slow(
    redeclare function fsteady = inact_fast.fsteady,
    redeclare function ftau = generalizedLogisticFit(y_min=0.00295, y_max=0.12+0.00295, x0=-0.060, sx=-1000/2.0, se=1)
  ) "inactivation gate for slow sodium channels (type2/h2)";
  Real inact_total = 0.635 * inact_fast.n + 0.365 * inact_slow.n;
equation
  open_ratio = act.n^3 * inact_total;
end SodiumChannel;
