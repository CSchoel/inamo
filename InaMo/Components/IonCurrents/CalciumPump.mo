within InaMo.Components.IonCurrents;
model CalciumPump "I_CaP for atrial cell model (Lindblad 1996)"
  extends OnePortVertical;
  extends TransmembraneCaFlow;
  extends InaMo.Icons.IonChannel;
  extends InaMo.Icons.Current(current_name="I_CaP");
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_sub;
  inner SI.Current i_ion = i;
  parameter SI.Current i_max = 0.16e-9;
equation
  i = i_max * michaelisMenten(ca.amount / v_sub, 0.2e-3);
end CalciumPump;
