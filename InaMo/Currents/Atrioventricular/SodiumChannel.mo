within InaMo.Components.IonCurrents;
model SodiumChannel "sodium channel as used by inada2009 and lindblad1996"
  extends SodiumChannelBase(ion_in=na_in);
  outer parameter SI.Concentration na_in;
end SodiumChannel;
