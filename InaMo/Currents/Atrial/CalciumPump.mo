within InaMo.Currents.Atrial;
model CalciumPump "I_CaP for atrial cell model (Lindblad 1996)"
  extends InaMo.Currents.Interfaces.OnePortVertical;
  extends InaMo.Concentrations.Interfaces.TransmembraneCaFlow;
  extends InaMo.Icons.InsideBottomOutsideTop;
  extends InaMo.Icons.LipidBilayerWithGap;
  extends InaMo.Icons.Current(current_name="I_CaP");
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_ca; // FIXME unsure if this is the correct variable
  inner SI.Current i_ion = i;
  parameter SI.Current i_max = 0.16e-9;
equation
  i = i_max * michaelisMenten(ca.amount / v_ca, 0.2e-3);
end CalciumPump;
