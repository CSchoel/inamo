within InaMo.Examples;
model SodiumCalciumExchangerRamp "I_NaCa during voltage clamp ramp, simulation setup from Convery 2000 for Figure S6 of Inada 2009"
  extends Modelica.Icons.Example;
  extends InaMo.Interfaces.CaConst;
  InaMo.Components.IonCurrents.SodiumCalciumExchanger naca
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Components.LipidBilayer l2(c=40e-12, use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  inner parameter SI.Temperature temp = 310;
  InaMo.Components.ExperimentalMethods.VoltageClamp vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  inner parameter SI.Concentration na_in = 8;
  inner parameter SI.Concentration na_ex = 140;
  inner parameter SI.Concentration ca_ex = 2;
  InaMo.Components.IonConcentrations.ConstantConcentration ca_sub(c_const=0.1e-3, vol=v_sub)
    annotation(Placement(transformation(extent = {{-51, -80}, {-17, -46}})));
  parameter Real t_ramp_start = 50e-3;
  parameter Real ramp_duration = 250e-3;
  parameter Real ramp_start = 60e-3;
  parameter Real ramp_end = -80e-3;
  parameter Real v_hold = -40e-3;
  Boolean ramp = time > t_ramp_start and time < t_ramp_start + ramp_duration;
protected
  parameter Real ramp_rate = (ramp_end - ramp_start) / ramp_duration;
equation
  if ramp then
    vc.v_stim = (time - t_ramp_start) * ramp_rate + ramp_start;
  else
    vc.v_stim = v_hold;
  end if;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, naca.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, naca.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
  connect(ca_sub.substance, naca.ca) annotation(
    Line(points = {{-34, -80}, {-14, -80}, {-14, -30}, {-28, -30}, {-28, -16}, {-28, -16}}));

annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>This example constitutes the base setup for the voltage ramp
      experiment performed by Convery 2000 whose data is used by Inada 2009
      for Figure S6. This model has to be simulated twice with different
      parameters for the AN and NH cell model and for the N cell model.
      This is done in SodiumCalciumExchangerRampInada.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow to see the whole 300 ms ramp in the plot</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
        <li>t_ramp_start: according to Figure 4D of Convery 2000</li>
        <li>ramp_duration: according to Convery 2000, p. 379</li>
        <li>ramp_start: according to Convery 2000, p. 397</li>
        <li>ramp_end: according to Convery 2000, p. 397</li>
        <li>v_hold: according to Figure 4D of Convery 2000</li>
      </ul>
    </html>
  ")
);
end SodiumCalciumExchangerRamp;
