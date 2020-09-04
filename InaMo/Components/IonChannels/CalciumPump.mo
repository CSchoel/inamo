within InaMo.Components.IonChannels;
model CalciumPump "I_CaP for atrial cell model (Lindblad 1996)"
  extends OnePortVertical;
  extends CaFlux(vol_ca=v_ca);
  extends InaMo.Icons.IonChannel;
  extends InaMo.Icons.Current(current_name="I_CaP");
  // TODO needs specific icon
  inner SI.Current i_ion = i;
  outer parameter SI.Volume v_ca;
  parameter SI.Current i_max = 0.16e-9;
equation
  i = i_max * michaelisMenten(ca.c, 0.2e-3);
end CalciumPump;
