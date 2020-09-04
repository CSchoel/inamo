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
    // NOTE: C++ and CellML-implementation set cal.v_eq to 6.2e-2 instead of
    //       6.21e-2. This seems more like a typo so we leave v_eq unchanged.
  );
  InaMo.Components.IonChannels.HyperpolarizationActivatedChannel hcn(g_max=1e-9, act.n.start=0.03825) // v_eq is given in table S7 directly as number
    annotation(Placement(transformation(extent = {{-12, -70}, {22, -36}}, rotation = 180)));
  // NOTE: v_eq is not given in Inada 2009 (E_st) => use value from Kurata 2002
  // NOTE: Kurata 2002 and C++ have positive sign for st.v_eq, but
  //       CellML has negative sign (which is also given in C++, but only
  //       in AN and NH cell where st.g_max = 0) => we use positive sign
  InaMo.Components.IonChannels.SustainedInwardChannel st(g_max=0.1e-9, v_eq=37.4e-3, act.n.start=0.1933, inact.n.start=0.4886)
    annotation(Placement(transformation(extent = {{22, -70}, {56, -36}}, rotation = 180)));
equation
  connect(l2.p, hcn.p);
  connect(l2.n, hcn.n);
  connect(l2.p, st.p);
  connect(l2.n, st.n);
end NCellBase;
