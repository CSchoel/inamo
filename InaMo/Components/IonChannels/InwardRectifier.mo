within InaMo.Components.IonChannels;
model InwardRectifier
  extends IonChannelElectric(g_max=12.5e-9, v_eq=-81.9e-3);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_K1");
  // TODO might need own icon
  outer parameter SI.Temperature temp "membrane temperature of enclosing component";
  // FIXME: FoRT should not need the "inner" keyword, this is just done to
  // help OMC with name lookup of variables due to a bug
  inner parameter Real FoRT = Modelica.Constants.F / temp / Modelica.Constants.R;
  parameter Boolean use_vact = true "use voltage-dependent activation gate? (only Inada 2009)";
  outer parameter SI.Concentration k_ex;
  Real n_pot = michaelisMenten(k_ex, 0.59) "[K+]_ex-dependent gating variable";
  // Note: R in mJ/(mol * K) -> R in J/(mol * K) by setting sx /= 1000
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  // Note: sx /= 1000 and sx *= 1000 cancel each other out => no change in sx
  InstantGate voltage_inact(
    redeclare function fn = generalizedLogisticFit(x0=v_eq-3.6e-3, sx=-1.393*FoRT)
  ) "voltage-dependent inactivation (Lindblad1997)";
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  // FIXME: this function decreases K1 current to 1/2 for low v and then
  //        increases it again for v > 30mV which leads to strange dual-mode
  //        shape of I-V curve => not sure if Inadas versio is sensible
  InstantGate voltage_act(
    redeclare function fn = generalizedLogisticFit(y_min=0.5, x0=-30e-3, sx=1000/5)
  ) "voltage-dependent activation (only Inada 2009)";
equation
  if use_vact then
    open_ratio = n_pot ^ 3 * voltage_inact.n * voltage_act.n;
  else
    open_ratio = n_pot ^ 3 * voltage_inact.n;
  end if;
end InwardRectifier;
