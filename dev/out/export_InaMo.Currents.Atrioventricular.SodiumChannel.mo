model SodiumChannel "fast sodium channel (I_Na) as used by Inada 2009"
  extends InaMo.Currents.Basic.SodiumChannelBase(ion_in = na_in);
  outer parameter SI.Concentration na_in "intracellular sodium concentration";
  annotation(
    Documentation(info = "<html>
  <p>This model only defines that the intracellular sodium concentration is
  assumed to be constant.
  All other channel properties are defined in the base class
  InaMo.Currents.Basic.SodiumChannelBase.</p>
</html>"));
end SodiumChannel;