within InaMo.Cells.Interfaces;
model CellBase "contains all code that is common among all cell types in Inada 2009"
  extends InaMo.Currents.Interfaces.TwoPinCell;
  extends InaMo.Icons.Cell;
  inner parameter Boolean use_ach = false "should acetylcholine sensitive potassium channel be included in the model";
  inner parameter SI.Concentration ach = 0 "concentration of acetylcholine available for I_Ach";
  inner parameter SI.Concentration na_in = 8 "intracellular sodium concentration";
  inner parameter SI.Concentration na_ex = 140 "extracellular sodium concentration";
  inner parameter PermeabilityFM na_p = p_from_g(253e-9, na_ex, 1, temp) "permeability of cell membrane to sodium ions";
  inner parameter SI.Concentration k_in = 140 "intracellular potassium concentration";
  inner parameter SI.Concentration k_ex = 5.4 "extracellular potassium concentration";
  inner parameter SI.Concentration ca_ex = 2 "extracellular calcium concentration";
  inner parameter SI.Temperature temp = 310 "cell medium temperature";
  function c_to_v "function used to determine cell volume based on membrane capacitance"
    input SI.Capacitance c_m "membrane capacitance";
    input SI.Volume v_low = 2.19911e-15 "low estimate for cell volume (obtained when c_m = c_low)";
    input SI.Volume v_high = 7.147123e-15 "high estimate for cell volume (obtained when c_m = c_low + c_span)";
    output SI.Volume v_cell "resulting total cell volume";
  protected
    SI.Capacitance c_low = 20e-12 "low value for c_m (where v_low is returned)";
    SI.Capacitance c_span = 45e-12 "span that must be added to c_m to reach an output of v_high";
  algorithm
    v_cell := (c_m - c_low) / c_span * (v_high - v_low) + v_low;
  annotation(Documentation(info="<html>
    <p>This function was obtained from the C++ code by Inada et al..
    Unfortunately it was completely undocumented, meaning that the
    documentation in this project represents our best guess of the rationale
    behind the function.</p>
    <p>&quot;v_low&quot; and &quot;v_high&quot; were named &quot;central&quot;
    and &quot;peripheral&quot; in the code and the function itself was named
    &quot;SEt_PArAMS&quot;, which indicates that perhaps the original intent
    of the function was to set multiple parameter values for the SAN cells
    (which use the terms &quot;central&quot; and &quot;peripheral&quot;.
    However, that interpretation does not make a lot of sense anymore when
    talking about AN, N, and NH cells, which is why we changed the parameter
    names.</p>
  </html>"));
  end c_to_v;
  // NOTE: Kurata 2002 uses v_cell = 3.5e-15, Inada 2009 gives no value
  // NOTE: but C++- and CellML-implementations use this formula
  parameter SI.Volume v_cell = c_to_v(l2.c) "total cell volume";
  inner parameter SI.Volume v_cyto = 0.46 * v_cell - v_sub "volume of cytosol"; // from Kurata 2002 (v_i)
  inner parameter SI.Volume v_sub = 0.01 * v_cell "volume of subspace"; // from Kurata 2002 (v_sub)
  inner parameter SI.Volume v_jsr = 0.0012 * v_cell "volume of junctional SR"; // from Kurata 2002 (v_rel)
  inner parameter SI.Volume v_nsr = 0.0116 * v_cell "volume of network SR"; // from Kurata 2002 (v_up)
  // v_k (E_K) is not given in Inada 2009 => calculate with nernst
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp) "equilibrium potential for potassium currents";
  InaMo.Currents.Basic.BackgroundChannel bg "I_b"
    annotation(Placement(visible=true, transformation(origin = {-51, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  replaceable InaMo.Currents.Atrioventricular.LTypeCalciumChannel cal "I_Ca,L"
    annotation(Placement(visible=true, transformation(origin = {-29, -53}, extent={{-17, -17}, {17, 17}}, rotation = 180)));
  InaMo.Currents.Atrioventricular.RapidDelayedRectifierChannel kr "I_K,r"
    annotation(Placement(visible=true, transformation(origin = {-63, -53}, extent={{-17, -17}, {17, 17}}, rotation = 180)));
  InaMo.Currents.Atrioventricular.SodiumCalciumExchanger naca "I_NaCa"
    annotation(Placement(visible=true, transformation(origin = {-17, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  InaMo.Currents.Atrioventricular.SodiumPotassiumPump nak "I_NaK / I_p"
    annotation(Placement(visible=true, transformation(origin = {51, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  InaMo.Components.LipidBilayer l2 "cell membrane as capacitor"
    annotation(Placement(visible=true, transformation(origin = {17, 53}, extent={{-17, -17}, {17, 17}}, rotation = 0)));
  InaMo.Currents.Atrioventricular.AcetylcholineSensitiveChannel c_ach if use_ach "I_Ach"
    annotation(Placement(visible = true, transformation(origin = {85, 53}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
equation
  connect(l2.p, p) annotation(
    Line(points = {{18, 70}, {16, 70}, {16, 86}, {-50, 86}, {-50, 100}, {-50, 100}}, color = {0, 0, 255}));
  connect(l2.n, n) annotation(
    Line(points = {{18, 36}, {16, 36}, {16, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(bg.p, p) annotation(
    Line(points = {{-50, 70}, {-50, 70}, {-50, 100}, {-50, 100}}, color = {0, 0, 255}));
  connect(bg.n, n) annotation(
    Line(points = {{-50, 36}, {-52, 36}, {-52, 2}, {-50, 2}, {-50, 0}}, color = {0, 0, 255}));
  connect(cal.p, p) annotation(
    Line(points = {{-28, -70}, {-30, -70}, {-30, -80}, {-88, -80}, {-88, 86}, {-50, 86}, {-50, 100}}, color = {0, 0, 255}));
  connect(cal.n, n) annotation(
    Line(points = {{-28, -36}, {-28, -36}, {-28, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(kr.p, p) annotation(
    Line(points = {{-62, -70}, {-64, -70}, {-64, -80}, {-88, -80}, {-88, 86}, {-50, 86}, {-50, 100}}, color = {0, 0, 255}));
  connect(kr.n, n) annotation(
    Line(points = {{-62, -36}, {-62, -36}, {-62, -16}, {-52, -16}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(naca.p, p) annotation(
    Line(points = {{-16, 70}, {-18, 70}, {-18, 86}, {-50, 86}, {-50, 100}, {-50, 100}}, color = {0, 0, 255}));
  connect(naca.n, n) annotation(
    Line(points = {{-16, 36}, {-18, 36}, {-18, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(nak.p, p) annotation(
    Line(points = {{52, 70}, {50, 70}, {50, 86}, {-50, 86}, {-50, 100}, {-50, 100}}, color = {0, 0, 255}));
  connect(nak.n, n) annotation(
    Line(points = {{52, 36}, {50, 36}, {50, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  connect(c_ach.p, p) annotation(
    Line(points = {{86, 70}, {84, 70}, {84, 86}, {-50, 86}, {-50, 100}, {-50, 100}}, color = {0, 0, 255}));
  connect(c_ach.n, n) annotation(
    Line(points = {{86, 36}, {84, 36}, {84, 26}, {-52, 26}, {-52, 0}, {-50, 0}}, color = {0, 0, 255}));
  annotation(
    Documentation(info="<html>
      <p>
        NOTE: Some parameter settings in this model have a few peculiarities.
        First, the volume terms v_cyto, v_sub, v_jsr, and v_nsr, are not given
        by Inata et al.. Formulas are instead taken from Kurata 2002, where
        the parameters are named v_i, v_sub, v_rel, and v_up respectively.
        The same formulas are also used in the C++ implementation by
        Inada et al., which also uses another formula to determine the total
        cell volume v_cell.
        This is captured here in the function c_to_v, whose rationale we had
        to guess from the undocumented C++ version.
      </p>
      <p>
        Second, the permeability na_p is not given directly by Inada et al.,
        but instead calculated from the conductivity g_na. We use the function
        p_from_g to convert the value from the article.
      </p>
      <p>
        Finally, a similar issue occurs with the equilibrium potentia v_k
        (called E_k in Inada 2009).
        Its value is also not given in the article, but can be calculated from
        potassium concentrations using the nernst function.
      </p>
    </html>"),
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
