within InaMo.Examples;
model SodiumCalciumExchangerLin "IV relationship of I_NaCa, base model for recreation of Figures from Matsuoka 1992, Kurata 2002 and Inada 2009"
  extends Modelica.Icons.Example;
  InaMo.Components.IonChannels.SodiumCalciumExchanger naca(k_NaCa=1e-9, ca_const=true)
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  inner parameter SI.Temperature temp = 310;
  InaMo.Components.LipidBilayer l2(c=40e-12, use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.Components.VoltageClamp vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  inner parameter SI.Concentration na_in = 8;
  inner parameter SI.Concentration na_ex = 140;
  inner parameter SI.Concentration ca_ex = 2;
  InaMo.Components.IonConcentrations.ConstantConcentration ca_sub(c_const=0.1e-3)
    annotation(Placement(transformation(extent = {{-51, -80}, {-17, -46}})));
  parameter SI.Voltage v_start = -140e-3;
initial equation
  vc.v_stim = v_start;
equation
  der(vc.v_stim) = 0.001;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, naca.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, naca.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
  connect(ca_sub.c, naca.ca) annotation(
    Line(points = {{-34, -80}, {-14, -80}, {-14, -30}, {-28, -30}, {-28, -16}, {-28, -16}}));
annotation(
  experiment(StartTime = 0, StopTime = 280, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>This example does not represent the settings of a specific Figure from
      a reference but instead serves as the basis for other models that
      use different variable settings for their experiment setup.</p>
      <p>This example uses a linear input current, because I_NaCa is modeled
      as an immediate current without activation or inactivation kinetics.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -140 to +140 mV</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end SodiumCalciumExchangerLin;
