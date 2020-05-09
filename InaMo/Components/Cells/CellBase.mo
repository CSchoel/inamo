within InaMo.Components.Cells;
model CellBase "contains all code that is common among all cell types in Inada 2009"
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  inner parameter SI.Concentration na_in = 8;
  inner parameter SI.Concentration na_ex = 140;
  inner parameter SI.Concentration na_p = p_from_g(253-9, na_ex, 1, temp);
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
  BackgroundChannel bg;
  LTypeCalciumChannel cal;
  RapidDelayedRectifierChannel kr;
  SodiumCalciumExchanger naca;
  SodiumPotassiumPump nak;
  LipidBilayer l2;
equation
  connect(l2.p, p);
  connect(l2.n, n);
  connect(l2.p, bg.p);
  connect(l2.n, bg.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  connect(l2.p, nak.p);
  connect(l2.n, nak.n);
end CellBase;
