within InaMo.Components.IonCurrents;
model SodiumChannelA "I_Na for atrial cell model (Lindblad 1996)"
  extends SodiumChannel(ion_in=na.amount / v_sub);
  extends TransmembraneNaFlow;
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_sub;
end SodiumChannelA;
