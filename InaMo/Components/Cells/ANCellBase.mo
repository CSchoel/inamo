within InaMo.Components.Cells;
partial model ANCellBase
  extends CellBase(
    bg(g_max=1.8e-9, v_eq=-52.5e-3),
    cal(g_max=18.5e-9, v_eq=62.1e-3, act.n.start=4.069e-5,
      inact_slow.n.start=0.9875, inact_fast.n.start=0.9985),
    kr(g_max=1.5e-9, v_eq=v_k,
      act_slow.n.start=0.04840, act_fast.n.start=0.07107, inact.n.start=0.9866),
    naca(k_NaCa=5.92e-9),
    nak(i_max=24.6e-9),
    l2(c=40e-12)
  );
  InwardRectifier kir(g_max=12.5e-9, v_eq=v_k);
  // TODO rename ativation to act for consistency
  SodiumChannel na(g_max=253e-9, activation.n.start=0.01227, inact_slow.n.start=0.6162, inact_fast.n.start=0.7170);
  TransientOutwardChannel to(g_max=20e-9, v_eq=v_k, act.n.start=8.857e-3,
    inact_slow.n.start=0.1503, inact_fast.n.start=0.8734);
equation
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
end ANCellBase;
