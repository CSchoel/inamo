within InaMo.Components.IonCurrents;
model CalciumPump "I_CaP for atrial cell model (Lindblad 1996)"
  extends OnePortVertical;
  extends CaFlux;
  extends InaMo.Icons.IonChannel;
  extends InaMo.Icons.Current(current_name="I_CaP");
  extends Modelica.Icons.UnderConstruction;
  inner SI.Current i_ion = i;
  parameter SI.Current i_max = 0.16e-9;
equation
  i = i_max * michaelisMenten(ca.c, 0.2e-3);
end CalciumPump;
