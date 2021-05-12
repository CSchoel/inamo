model InwardRectifier "inward rectifying potassium channel (I_K1)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max = 12.5e-9, v_eq = -81.9e-3);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name = "I_K1");
  outer parameter SI.Temperature temp "membrane temperature of enclosing component";
  // FIXME: FoRT should not need the "inner" keyword, this is just done to
  // help OMC with name lookup of variables due to a bug
  inner parameter Real FoRT = Modelica.Constants.F / temp / Modelica.Constants.R "helper variable to simplyfiy equations";
  parameter Boolean use_vact = true "use voltage-dependent activation gate? (only Inada 2009)";
  outer parameter SI.Concentration k_ex "extracellular potassium concentration";
  Real n_pot = michaelisMenten(k_ex, 0.59) "[K+]_ex-dependent gating variable";
  // Note: R in mJ/(mol * K) -> R in J/(mol * K) by setting sx /= 1000
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  // Note: sx /= 1000 and sx *= 1000 cancel each other out => no change in sx
  InstantGate voltage_inact(redeclare function fn = genLogistic(x0 = v_eq - 3.6e-3, sx = -1.393 * FoRT)) "voltage-dependent inactivation (Lindblad 1996)";
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  InstantGate voltage_act(redeclare function fn = genLogistic(y_min = 0.5, x0 = -30e-3, sx = 1000 / 5)) "voltage-dependent activation (only Inada 2009)";
equation
  if use_vact then
    open_ratio = n_pot ^ 3 * voltage_inact.n * voltage_act.n;
  else
    open_ratio = n_pot ^ 3 * voltage_inact.n;
  end if;
  annotation(
    Documentation(info = "<html>
  <p>This model is an extension of the inward rectifier in Lindblad 1996 by
  Inada et al..
  It includes an additional voltage-dependent activation term
  <code>voltage_act</code>, which decreases the current to 50% for low
  voltages and then increases it back to its full value for v > 30 mV, which
  gives the I-V curve a dual mode shape.
  We are not sure if this change is sensible, but we include it since it is
  both present in the article and the C++ code of Inada 2009.</p>
</html>"));
end InwardRectifier;