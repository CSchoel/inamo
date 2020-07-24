within InaMo.Components.Cells;
model CellBase "contains all code that is common among all cell types in Inada 2009"
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  inner parameter SI.Concentration na_in = 8;
  inner parameter SI.Concentration na_ex = 140;
  inner parameter PermeabilityFM na_p = p_from_g(253e-9, na_ex, 1, temp);
  inner parameter SI.Concentration k_in = 140;
  inner parameter SI.Concentration k_ex = 5.4;
  inner parameter SI.Concentration ca_ex = 2;
  inner parameter SI.Concentration temp = 310;
  function c_to_v
    input SI.Capacitance c_m;
    input SI.Volume v_center = 2.19911e-15;
    input SI.Volume v_periphery = 7.147123e-15;
    output SI.Volume v_cell;
  protected
    SI.Capacitance c_off = 20e-12;
    SI.Capacitance c_rel = 45e-12;
  algorithm
    v_cell := (c_m - c_off) / c_rel * (v_periphery - v_center) + v_center;
  end c_to_v;
  // NOTE: Kurata 2002 uses v_cell = 3.5e-15, Inada 2009 gives no value
  // NOTE: but C++- and CellML-implementations use this formula
  parameter SI.Volume v_cell = c_to_v(l2.c);
  inner parameter SI.Volume v_cyto = 0.46 * v_cell - v_sub; // from Kurata 2002 (v_i)
  inner parameter SI.Volume v_sub = 0.01 * v_cell; // from Kurata 2002 (v_sub)
  inner parameter SI.Volume v_jsr = 0.0012 * v_cell; // from Kurata 2002 (v_rel)
  inner parameter SI.Volume v_nsr = 0.0116 * v_cell; // from Kurata 2002 (v_up)
  // v_k (E_K) is not given in Inada 2009 => calculate with nernst
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp);
  BackgroundChannel bg;
  replaceable LTypeCalciumChannel cal;
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
