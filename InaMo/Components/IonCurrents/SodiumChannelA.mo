within InaMo.Components.IonCurrents;
model SodiumChannelA "I_Na for atrial cell model (Lindblad 1996)"
  extends SodiumChannel(na_const=false, na_in=na.c);
  extends NaFlux;
  extends Modelica.Icons.UnderConstruction;
end SodiumChannelA;
