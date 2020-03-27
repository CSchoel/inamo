within InaMo.Examples;
model SustainedInwardSteady
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  SustainedInwardChannel st;
  Real act_steady = st.act.fsteady(v);
  Real act_tau = st.act.tau;
  Real inact_steady = inact_tau * st.inact.falpha(v);
  Real inact_tau = 1 / (st.inact.falpha(v) + st.inact.fbeta(v));
  SI.Voltage v(start=-0.08, fixed=true);
  function qa
    input Real x;
    output Real y;
  algorithm
    y := 1 / (1 + exp(-(x + 75)/5));
  end qa;
  function qi
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
  function tau_qa
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
  function tau_qi
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
  Real act_steady2 = qa(1000 * v);
  Real inact_steady2 = qi(1000 * v);
  Real act_tau2 = 0.001 * tau_qa(1000 * v);
  Real inact_tau2 = 0.001 * tau_qi(1000 * v);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, st.p);
  connect(l2.n, st.n);
end SustainedInwardSteady;
