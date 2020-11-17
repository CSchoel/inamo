within InaMo.Examples;
model AllCells
  FullCellCurrentPulses an(redeclare ANCell cell, cc.i_pulse=-1.2e-9);
  FullCellSpon n(redeclare NCell cell);
  FullCellCurrentPulses nh(redeclare NHCell cell, cc.i_pulse=-0.95e-9);
  extends Modelica.Icons.Example;
annotation(
  experiment(StartTime = 0, StopTime = 2.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(an|n|nh)\\.cell\\.(v|ca\\.(sub|cyto)\\.con)"),
  Documentation(info="
    <html>
      <p>To reproduce the upper part of Figure S7 from Inada 2009, plot
      an.cell.v, n.cell.v and nh.cell.v against time.
      To reproduce the lower part, plot an.cell.ca.cyto.substance.amount,
      n.cell.ca.cyto.substance.amount, and nh.cell.ca.cyto.substance.amount against time.
      As time period for each cell type choose the first pulse that occurs
      after one second has passed.</p>

      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow to see more than one action potential</li>
        <li>Tolerance: detect changes of a single picoampere</li>
        <li>Interval: small enough to follow time course of current during peak</li>
        <li>{an, nh}.cc.i_hold: assumed as zero (not given explicitly in Inada 2009)</li>
        <li>{an, nh}.cc.i_pulse: manually chosen to obtain best fit for plots</li>
        <li>{an, nh}.cc.d_pulse: according to the description of Figure 1 in Inada 2009</li>
        <li>{an, nh}.cc.d_hold: manually chosen to obtain best fit for plot (300 ms instead of 350 ms as according to Figure 1 in Inada 2009)</li>
        <li>
          {an, nh}.cell.use_ach: set to false, because the acetylcholine
          concentration {an, nh, n}.cell.ach is not given in the C++ code and
          the CellML code sets it to 0, effectively disabling the channel.
        </li>
      </ul>
      <p>NOTE: Inada et al. do not specify the experiment protocol used for
      figure S7. We assume that it is the same or similar to the experiment
      protocol used for figure 1.
      However, even for this figure in the main article, the value for i_stim
      is only given as &quot;k x Threshold&quot; with some numeric value for k
      and no clear definition of what the threshold value is.
      d_pulse is given as 350 ms, but we obtained a better fit with d_pulse =
      300 ms.
      i_hold is not given, but can be assumed to be zero.</p>
      <p>NOTE: For AN and NH cells the voltage plot shows a lower resting
      potential and a slightly narrower AP with respect to figure S7.
      For N cells, the internal Ca2+ concentration is significantly lower than
      in figure S7.</p>
    </html>
  ")
);
end AllCells;
