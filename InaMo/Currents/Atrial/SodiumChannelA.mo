within InaMo.Currents.Atrial;
model SodiumChannelA "I_Na for atrial cell model (Lindblad 1996)"
  extends SodiumChannelBase(ion_in=na.amount / v_cyto);
  extends TransmembraneNaFlow;
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_cyto; // FIXME unsure if this is the correct variable
end SodiumChannelA;
