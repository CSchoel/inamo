within InaMo.Components.IonChannels;
model LTypeCalciumChannel "I_Ca,L"
  extends IonChannelElectric(G_max=18.5e-9, V_eq=62.1e-3);
  IonConcentration c_sub;
  parameter Real V_sub = 1;
  function freakGoldman
    input Real x;
    output Real y;
    function g1 = goldmanFit(x0=-35, sx=-1000/2.5, sy=26.12*2.5/1000);
    function g2 = goldmanFit(sx=-0.208e3, sy=78.11/0.208e3);
  algorithm
    y := g1(x) + g2(x);
  end freakGoldman;
  GateABS act(
    redeclare function falpha = freakGoldman,
    redeclare function fbeta = goldmanFit(x0=5e-3, sx=0.4e3, sy=10.52/0.4e3),
    redeclare function fsteady = generalizedLogisticFit(x0=-3.2e-3, sx=1000/6.61), // parameters for AN node
    V = v
  );
  GateTS inact_slow(
    redeclare function ftau = generalizedLogisticFit(y_min=0.06, y_max=1.08171+0.06, x0=-40e-3, nu=0.5, sx=1000/sqrt(185.67)),
    redeclare function fsteady = generalizedLogisticFit(x0=-29e-3, sx=-1000/6.31),
    V = v
  );
  GateTS inact_fast(
    redeclare function ftau = generalizedLogisticFit(y_min=0.01, y_max=0.1539+0.01, x0=-40e-3, nu=0.5, sx=1000/sqrt(138.04)),
    redeclare function fsteady = inact_slow.fsteady,
    V = v
  );
  Real inact_total = 0.675 * inact_fast.n + 0.325 * inact_slow.n;
equation
  open_ratio = act.n * inact_total;
  c_sub.rate = -i / 2 / Modelica.Constants.F / V_sub;
end LTypeCalciumChannel;
