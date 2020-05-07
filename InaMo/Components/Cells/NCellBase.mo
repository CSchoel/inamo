within InaMo.Components.Cells;
partial model NCellBase
  inner parameter SI.Concentration na_in = 8;
  inner parameter SI.Concentration na_ex = 140;
  //inner parameter SI.Concentration na_p = ;
  inner parameter SI.Concentration k_in = 140;
  inner parameter SI.Concentration k_ex = 5.4;
  inner parameter SI.Concentration ca_ex = 2;
  inner parameter SI.Concentration temp = 310;
  parameter SI.Volume v_cell = 3.4e-9;
  inner parameter SI.Volume v_cyto = 0.46 * v_cell - v_sub; // from Kurata 2002 (v_i)
  inner parameter SI.Volume v_sub = 0.01 * v_cell; // from Kurata 2002 (v_sub)
  inner parameter SI.Volume v_jsr = 0.0012 * v_cell; // from Kurata 2002 (v_rel)
  inner parameter SI.Volume v_nsr = 0.0116 * v_cell; // from Kurata 2002 (v_up)
  BackgroundChannel bg(g_max=1.2e-9, v_eq=-22.5e-3);
  HyperpolarizationActivatedChannel hcn(g_max=1e-9);
  // InwardRectifier kir;
  SustainedInwardChannel st(g_max=0.1e-9);
  LTypeCalciumChannel cal(v_sub=v_sub, g_max=9e-9, v_eq=62.1e-3);
  RapidDelayedRectifierChannel kr(g_max=3.5e-9);
  SodiumCalciumExchanger naca(v_sub=v_sub, k_NaCa=2.14e-9);
  // SodiumChannel na;
  SodiumPotassiumPump nak(i_max=143e-9);
  // TransientOutwardChannel to;
  LipidBilayer l2(c=29e-12);
equation
  connect(l2.p, bg.p);
  connect(l2.n, bg.n);
  connect(l2.p, hcn.p);
  connect(l2.n, hcn.n);
  // connect(l2.p, kir.p);
  // connect(l2.n, kir.n);
  connect(l2.p, st.p);
  connect(l2.n, st.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  // connect(l2.p, na.p);
  // connect(l2.n, na.n);
  connect(l2.p, nak.p);
  connect(l2.n, nak.n);
  // connect(l2.p, to.p);
  // connect(l2.n, to.n);
end NCellBase;
