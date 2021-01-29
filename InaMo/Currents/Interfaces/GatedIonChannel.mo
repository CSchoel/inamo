within InaMo.Currents.Interfaces;
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
annotation(Documentation(info="<html>
  <p>This is the base model for all ion channel components in InaMo.</p>
  <p>It defines the <code>inner</code> variables used in other base components
  and leaves the two variables <code>open_ratio</code> and
  <code>i_open</code> open for definition in subclasses.</p>
  <p>Typically this interface is not used on its own in favor of the more
  specific interfaces InaMo.Currents.Interfaces.IonChannelElectric and
  InaMo.Currents.Interfaces.IonChannelGHK.</p>
</html>"));
end GatedIonChannel;
