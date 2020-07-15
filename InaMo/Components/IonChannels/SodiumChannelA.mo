within InaMo.Components.IonChannels;
model SodiumChannelA "I_Na for atrial cell model (Lindblad 1996)"
  extends SodiumChannel;
  extends NaFlux(vol=v_cyto);
  outer parameter SI.Volume v_cyto;
end SodiumChannelA;
