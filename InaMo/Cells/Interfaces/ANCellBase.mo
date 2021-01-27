within InaMo.Cells.Interfaces;
partial model ANCellBase "base model for atrio-nodal cells"
  extends CellBase(
    bg(g_max=1.8e-9, v_eq=-52.5e-3),
    cal(g_max=18.5e-9, v_eq=62.1e-3, act.n.start=4.069e-5,
      inact_slow.n.start=0.9875, inact_fast.n.start=0.9985),
    kr(g_max=1.5e-9, v_eq=v_k,
      act_slow.n.start=0.04840, act_fast.n.start=0.07107, inact.n.start=0.9866),
    naca(k_NaCa=5.92e-9),
    nak(i_max=24.6e-12),
    l2(c=40e-12)
  );
  InaMo.Currents.Atrioventricular.InwardRectifier kir(g_max=12.5e-9, v_eq=v_k) "I_K1"
    annotation(Placement(transformation(extent = {{-12, -70}, {22, -36}}, rotation = 180)));
  InaMo.Currents.Atrioventricular.SodiumChannel na(act.n.start=0.01227, inact_slow.n.start=0.6162, inact_fast.n.start=0.7170) "I_Na"
    annotation(Placement(transformation(extent = {{22, -70}, {56, -36}}, rotation = 180)));
  InaMo.Currents.Atrioventricular.TransientOutwardChannel to(g_max=20e-9, v_eq=v_k, act.n.start=8.857e-3,
    inact_slow.n.start=0.1503, inact_fast.n.start=0.8734) "I_to"
    annotation(Placement(transformation(extent = {{56, -70}, {90, -36}}, rotation = 180)));
equation
  connect(kir.p, p) annotation(
    Line(points = {{6, -70}, {4, -70}, {4, -80}, {-88, -80}, {-88, 86}, {-50, 86}, {-50, 100}}, color = {0, 0, 255}));
  connect(kir.n, n) annotation(
    Line(points = {{6, -36}, {6, -26}, {-28, -26}, {-28, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(na.p, p) annotation(
    Line(points = {{40, -70}, {38, -70}, {38, -80}, {-88, -80}, {-88, 86}, {-50, 86}, {-50, 100}}, color = {0, 0, 255}));
  connect(na.n, n) annotation(
    Line(points = {{40, -36}, {40, -36}, {40, -26}, {-28, -26}, {-28, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(to.p, p) annotation(
    Line(points = {{74, -70}, {72, -70}, {72, -80}, {-88, -80}, {-88, 86}, {-50, 86}, {-50, 100}}, color = {0, 0, 255}));
  connect(to.n, n) annotation(
    Line(points = {{74, -36}, {74, -36}, {74, -26}, {-28, -26}, {-28, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
end ANCellBase;
