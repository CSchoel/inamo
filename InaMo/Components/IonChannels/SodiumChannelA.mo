within InaMo.Components.IonChannels;
model SodiumChannelA "I_Na for atrial cell model (Lindblad 1996)"
  extends SodiumChannel(na_const=false, na_in=na.c);
  extends NaFlux(vol_na=v_cyto);
  extends Modelica.Icons.UnderConstruction;
  outer parameter SI.Volume v_cyto;
end SodiumChannelA;
