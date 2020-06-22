within InaMo.Components.Cells;
partial model NCellBase
  extends CellBase(
    bg(g_max=1.2e-9, v_eq=-22.5e-3),
    redeclare LTypeCalciumChannelN cal(
      g_max=9e-9, v_eq=62.1e-3, act.n.start=1.533e-4,
      inact_slow.n.start=0.4441, inact_fast.n.start=0.6861),
    kr(g_max=3.5e-9, v_eq=v_k,
      act_slow.n.start=0.1287, act_fast.n.start=0.6067, inact.n.start=0.9775),
    naca(k_NaCa=2.14e-9),
    nak(i_max=143e-12),
    l2(c=29e-12)
  );
  HyperpolarizationActivatedChannel hcn(g_max=1e-9, act.n.start=0.03825); // v_eq is given in table S7 directly as number
  SustainedInwardChannel st(g_max=0.1e-9, act.n.start=0.1933, inact.n.start=0.4886); // v_eq is not given in Inada 2009 (E_st) => use value from Kurata 2002
equation
  connect(l2.p, hcn.p);
  connect(l2.n, hcn.n);
  connect(l2.p, st.p);
  connect(l2.n, st.n);
end NCellBase;
