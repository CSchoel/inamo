within InaMo.Components.Cells;
model CellBase "contains all code that is common among all cell types in Inada 2009"
  extends TwoPinCell;
  import InaMo.Icons.Cell;
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
  InaMo.Components.IonChannels.BackgroundChannel bg
    annotation(Placement(visible=true, transformation(origin = {-51, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  replaceable InaMo.Components.IonChannels.LTypeCalciumChannel cal
    annotation(Placement(visible=true, transformation(origin = {-29, -53}, extent={{-17, -17}, {17, 17}}, rotation = 180)));
  InaMo.Components.IonChannels.RapidDelayedRectifierChannel kr
    annotation(Placement(visible=true, transformation(origin = {-63, -53}, extent={{-17, -17}, {17, 17}}, rotation = 180)));
  InaMo.Components.IonChannels.SodiumCalciumExchanger naca
    annotation(Placement(visible=true, transformation(origin = {-17, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  InaMo.Components.IonChannels.SodiumPotassiumPump nak
    annotation(Placement(visible=true, transformation(origin = {51, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  InaMo.Components.LipidBilayer l2
    annotation(Placement(visible=true, transformation(origin = {17, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
equation
  connect(l2.p, p) annotation(
    Line(points = {{18, 70}, {18, 70}, {18, 86}, {0, 86}, {0, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(l2.n, n) annotation(
    Line(points = {{18, 36}, {16, 36}, {16, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(bg.p, p) annotation(
    Line(points = {{-50, 70}, {-50, 70}, {-50, 86}, {0, 86}, {0, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(bg.n, n) annotation(
    Line(points = {{-50, 36}, {-52, 36}, {-52, 2}, {-50, 2}, {-50, 0}}, color = {0, 0, 255}));
  connect(cal.p, p) annotation(
    Line(points = {{-28, -70}, {-30, -70}, {-30, -80}, {-88, -80}, {-88, 86}, {0, 86}, {0, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(cal.n, n) annotation(
    Line(points = {{-28, -36}, {-28, -36}, {-28, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(kr.p, p) annotation(
    Line(points = {{-62, -70}, {-64, -70}, {-64, -80}, {-88, -80}, {-88, 86}, {0, 86}, {0, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(kr.n, n) annotation(
    Line(points = {{-62, -36}, {-62, -36}, {-62, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(naca.p, p) annotation(
    Line(points = {{-16, 70}, {-16, 70}, {-16, 86}, {0, 86}, {0, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(naca.n, n) annotation(
    Line(points = {{-16, 36}, {-18, 36}, {-18, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(nak.p, p) annotation(
    Line(points = {{52, 70}, {52, 70}, {52, 86}, {0, 86}, {0, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(nak.n, n) annotation(
    Line(points = {{52, 36}, {50, 36}, {50, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  annotation(
    Diagram(graphics={
      Rectangle(
        fillColor = {211, 211, 211},
        pattern = LinePattern.None,
        fillPattern = FillPattern.Solid,
        extent = {{-100, 60}, {100, -60}}
      )
    })
  );
end CellBase;
