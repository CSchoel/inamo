partial model IonChannelElectric "ion channel based on electrical analog (voltage source + conductor)"
  extends GatedIonChannel;
  parameter SI.ElectricPotential v_eq "equilibrium potential";
  parameter SI.Conductance g_max "maximum conductance";
  SI.Conductance g(nominal = 1e-9) = open_ratio * g_max "ion conductance";
equation
  i_open = g_max * (v - v_eq);
  annotation(
    Documentation(info = "<html>
  <p>This model is the base class for most ion channels in InaMo.</p>
  <p>It provides the electrical equations for <code>i_open</code> and
  therefore only requires to define <code>open_ratio</code> based on the
  current state of the gates in the channel.</p>
</html>"));
end IonChannelElectric;