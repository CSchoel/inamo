within InaMo.Components.IonCurrents;
partial model GatedIonChannel "ion channel with voltage dependent gates"
  extends OnePortVertical;
  extends InaMo.Icons.InsideBottomOutsideTop;
  extends InaMo.Icons.LipidBilayerWithGap;
  inner SI.Voltage v_gate = v "voltage used for activation/inactivation gates";
  inner SI.Current i_ion = i "current used for ion flux";
  Real open_ratio "ratio between 0 (fully closed) and 1 (fully open)";
  Real i_open(nominal=1e-12) "i if open_ratio = 1";
equation
  i = open_ratio * i_open;
end GatedIonChannel;
