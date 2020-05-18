within InaMo.Components.IonChannels;
model LTypeCalciumChannel "I_Ca,L"
  extends IonChannelElectric(g_max=18.5e-9, v_eq=62.1e-3);
  parameter Boolean ca_const = false;
  parameter Boolean use_ach = false "model ACh dependence or not";
  IonConcentration ca_sub if not ca_const;
  outer parameter SI.Concentration ach if use_ach;
  outer parameter SI.Volume v_sub if not ca_const;
  function freakGoldman
    input Real x;
    output Real y;
    function g1 = goldmanFit(x0=-35e-3, sx=-1000/2.5, sy=26.12*2.5);
    function g2 = goldmanFit(sx=-0.208e3, sy=78.11/0.208);
  algorithm
    y := g1(x) + g2(x);
  end freakGoldman;
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = freakGoldman,
      redeclare function fbeta = goldmanFit(x0=5e-3, sx=0.4e3, sy=10.52/0.4)
    ),
    redeclare function fsteady = generalizedLogisticFit(x0=-3.2e-3, sx=1000/6.61) // parameters for AN node
  );
  GateTS inact_slow(
    redeclare function ftau = negSquaredExpFit(y_min=0.06, y_max=1.08171+0.06, x0=-40e-3, sx=1000/sqrt(138.04)),
    redeclare function fsteady = generalizedLogisticFit(x0=-29e-3, sx=-1000/6.31)
  );
  GateTS inact_fast(
    redeclare function ftau = negSquaredExpFit(y_min=0.01, y_max=0.1539+0.01, x0=-40e-3, sx=1000/sqrt(185.67)),
    redeclare function fsteady = inact_slow.fsteady
  );
  Real inact_total = 0.675 * inact_fast.n + 0.325 * inact_slow.n;
protected
  // TODO check order of magnitude for MM-constant
  Real ach_factor = if use_ach then michaelisMenten(ach, 0.9e-4) else 1;
equation
  open_ratio = act.n * inact_total * ach_factor;
  if not ca_const then
    ca_sub.rate = -i / 2 / Modelica.Constants.F / v_sub;
  end if;
end LTypeCalciumChannel;
