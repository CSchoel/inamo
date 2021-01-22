within InaMo.Components.Cells;
partial model NHCellBase "base model for nodal-his cells"
  extends CellBase(
    bg(g_max=2e-9, v_eq=-40e-3),
    cal(g_max=21e-9, v_eq=62.1e-3, act.n.start=5.025e-5,
      inact_slow.n.start=0.9831, inact_fast.n.start=0.9981),
    kr(g_max=2e-9, v_eq=v_k,
      act_slow.n.start=0.07024, act_fast.n.start=0.09949, inact.n.start=0.9853),
    naca(k_NaCa=5.92e-9),
    nak(i_max=197e-12),
    l2(c=40e-12)
  );
  InaMo.Components.IonCurrents.InwardRectifier kir(g_max=15e-9, v_eq=v_k)
    annotation(Placement(transformation(extent = {{-12, -70}, {22, -36}}, rotation = 180)));
  InaMo.Components.IonCurrents.SodiumChannel na(act.n.start=0.01529, inact_slow.n.start=0.5552, inact_fast.n.start=0.6438)
    annotation(Placement(transformation(extent = {{22, -70}, {56, -36}}, rotation = 180)));
  InaMo.Components.IonCurrents.TransientOutwardChannel to(g_max=14e-9, v_eq=v_k, act.n.start=9.581e-3,
    inact_slow.n.start=0.1297, inact_fast.n.start=0.8640)
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
end NHCellBase;
