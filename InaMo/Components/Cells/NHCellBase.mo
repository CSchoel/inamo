within InaMo.Components.Cells;
partial model NHCellBase
  extends CellBase(
    bg(g_max=2e-9, v_eq=-40e-3),
    cal(g_max=21e-9, v_eq=62.1e-3, act.n.start=5.025e-5,
      inact_slow.n.start=0.9831, inact_fast.n.start=0.9981),
    kr(g_max=2e-9, v_eq=v_k,
      act_slow.n.start=0.07024, act_fast.n.start=0.09949, inact.n.start=0.9853),
    naca(k_NaCa=5.92e-9),
    nak(i_max=197e-9),
    l2(c=40e-12)
  );
  InwardRectifier kir(g_max=15e-9, v_eq=v_k);
  // TODO rename ativation to act for consistency
  SodiumChannel na(g_max=253e-9, activation.n.start=0.01529, inact_slow.n.start=0.5552, inact_fast.n.start=0.6438);
  TransientOutwardChannel to(g_max=14e-9, v_eq=v_k, act.n.start=9.581e-3,
    inact_slow.n.start=0.1297, inact_fast.n.start=0.8640);
equation
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
end NHCellBase;
