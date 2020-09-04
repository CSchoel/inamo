within InaMo.Components.Cells;
partial model ANCellBase
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
  InaMo.Components.IonChannels.InwardRectifier kir(g_max=12.5e-9, v_eq=v_k)
    annotation(Placement(transformation(extent = {{-12, -70}, {22, -36}}, rotation = 180)));
  InaMo.Components.IonChannels.SodiumChannel na(act.n.start=0.01227, inact_slow.n.start=0.6162, inact_fast.n.start=0.7170)
    annotation(Placement(transformation(extent = {{22, -70}, {56, -36}}, rotation = 180)));
  InaMo.Components.IonChannels.TransientOutwardChannel to(g_max=20e-9, v_eq=v_k, act.n.start=8.857e-3,
    inact_slow.n.start=0.1503, inact_fast.n.start=0.8734)
    annotation(Placement(transformation(extent = {{56, -70}, {90, -36}}, rotation = 180)));
equation
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
end ANCellBase;
