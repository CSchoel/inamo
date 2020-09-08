within InaMo.Examples;
model SustainedInwardSteady "steady state of I_st, recreates Figure S5A from Inada 2009"
  extends Modelica.Icons.Example;
  InaMo.Components.LipidBilayer l2(use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.Components.ExperimentalMethods.VoltageClamp vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  InaMo.Components.IonCurrents.SustainedInwardChannel st
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  Real act_steady = st.act.fsteady(v);
  Real act_tau = st.act.ftau(v);
  Real inact_steady = inact_tau * st.inact.falpha(v);
  Real inact_tau = 1 / (st.inact.falpha(v) + st.inact.fbeta(v));
  SI.Voltage v(start=-0.08, fixed=true);
  function qa "direct copy of activation steady state from Kurata 2002"
    input Real x;
    output Real y;
  algorithm
    y := 1 / (1 + exp(-(x + 57)/5));
  end qa;
  function qi "direct copy of inactivation steady state from Kurata 2002"
    input Real x;
    output Real y;
  protected
    Real alpha;
    Real beta;
  algorithm
    alpha := 0.1504 / (3100 * exp(x/13) + 700 * exp(x/70));
    beta := 0.1504 / (95 * exp(-x/10) + 50 * exp(-x/700)) + 0.000229/(1 + exp(-x/5));
    y := alpha / (alpha + beta);
  end qi;
  function tau_qa "direct copy of activation time constant from Kurata 2002"
    input Real x;
    output Real y;
  protected
    Real alpha;
    Real beta;
  algorithm
    alpha := 1 / (0.15 * exp(-x/11) + 0.2 * exp(-x/700));
    beta := 1 / (16 * exp(x/8) + 15 * exp(x/50));
    y := 1 / (alpha + beta);
  end tau_qa;
  function tau_qi "direct copy of inactivation time constant from Kurata 2002"
    input Real x;
    output Real y;
  protected
    Real alpha;
    Real beta;
  algorithm
    alpha := 0.1504 / (3100 * exp(x/13) + 700 * exp(x/70));
    beta := 0.1504 / (95 * exp(-x/10) + 50 * exp(-x/700)) + 0.000229/(1 + exp(-x/5));
    y := 1 / (alpha + beta);
  end tau_qi;
  Real act_steady2 = qa(1000 * v) "steady state of activation (Kurata 2002)";
  Real inact_steady2 = qi(1000 * v) "steady state of inactivation (Kurata 2002)";
  Real act_tau2 = 0.001 * tau_qa(1000 * v) "time constant of activation (Kurata 2002)";
  Real inact_tau2 = 0.001 * tau_qi(1000 * v) "steady state of inactivation (Kurata 2002)";
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, st.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, st.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 140, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(act_steady|act_tau|inact_steady|inact_tau)2?|v|vc.v"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S5A from Inada 2009, plot act_steady
      against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -80 to 60 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
      </ul>
    </html>
  ")
);
end SustainedInwardSteady;
