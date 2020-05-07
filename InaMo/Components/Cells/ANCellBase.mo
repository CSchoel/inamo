within InaMo.Components.Cells;
partial model ANCellBase
  inner parameter SI.Concentration na_in = 8;
  inner parameter SI.Concentration na_ex = 140;
  inner parameter SI.Concentration na_p = 1.4e-15; // from Table S17 in Inada 2009
  inner parameter SI.Concentration k_in = 140;
  inner parameter SI.Concentration k_ex = 5.4;
  inner parameter SI.Concentration ca_ex = 2;
  inner parameter SI.Concentration temp = 310;
  parameter SI.Volume v_cell = 3.4e-9;
  inner parameter SI.Volume v_cyto = 0.46 * v_cell - v_sub; // from Kurata 2002 (v_i)
  inner parameter SI.Volume v_sub = 0.01 * v_cell; // from Kurata 2002 (v_sub)
  inner parameter SI.Volume v_jsr = 0.0012 * v_cell; // from Kurata 2002 (v_rel)
  inner parameter SI.Volume v_nsr = 0.0116 * v_cell; // from Kurata 2002 (v_up)
  // v_k (E_K) is not given in Inada 2009 => calculate with nernst
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp);
  BackgroundChannel bg(g_max=1.8e-9, v_eq=-52.5e-3);
  // HyperpolarizationActivatedChannel hcn(g_max=1e-9, act.n.start=0.03825);
  InwardRectifier kir(g_max=12.5e-9, v_eq=v_k);
  // SustainedInwardChannel st(g_max=0.1e-9, act.n.start=0.1933, inact.n.start=0.4886);
  LTypeCalciumChannel cal(g_max=18.5e-9, v_eq=62.1e-3, act.n.start=4.069e-5,
    inact_slow.n.start=0.9875, inact_fast.n.start=0.9985);
  RapidDelayedRectifierChannel kr(g_max=1.5e-9, v_eq=v_k,
    act_slow.n.start=0.04840, act_fast.n.start=0.07107, inact.n.start=0.9866);
  SodiumCalciumExchanger naca(k_NaCa=5.92e-9);
  // TODO rename ativation to act for consistency
  SodiumChannel na(activation.n.start=0.01227, inact_slow.n.start=0.6162, inact_fast.n.start=0.7170);
  SodiumPotassiumPump nak(i_max=24.6e-9);
  TransientOutwardChannel to(g_max=20, v_eq=v_k, act.n.start=8.857e-3,
    inact_slow.n.start=0.1503, inact_fast.n.start=0.8734);
  LipidBilayer l2(c=40e-12);
equation
  connect(l2.p, bg.p);
  connect(l2.n, bg.n);
  // connect(l2.p, hcn.p);
  // connect(l2.n, hcn.n);
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  // connect(l2.p, st.p);
  // connect(l2.n, st.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, nak.p);
  connect(l2.n, nak.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
end ANCellBase;
