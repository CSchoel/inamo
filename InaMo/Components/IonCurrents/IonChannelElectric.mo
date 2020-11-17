within InaMo.Components.IonCurrents;
partial model IonChannelElectric "ion channel based on electrical analog (voltage source + conductor)"
  extends GatedIonChannel;
  parameter SI.ElectricPotential v_eq "equilibrium potential";
  parameter SI.Conductance g_max "maximum conductance";
  SI.Conductance g(nominal=1e-9) = open_ratio * g_max "ion conductance";
equation
  i_open = g_max * (v - v_eq);
end IonChannelElectric;
