within InaMo.Components.IonChannels;
model InwardRectifier
  extends IonChannelElectric(G_max=12.5e-9, V_eq=-81.9e-3);
  parameter SI.Temperature T = SI.Conversions.from_degC(35) "membrane temperature";
  parameter MobileIon potassium(c_in=100, c_ex=5, p=0, z=1);
  parameter Real FoRT = Modelica.Constants.F / T / Modelica.Constants.R;
  parameter Boolean use_vact = true "use voltage-dependent activation gate? (only Inada 2009)";
  InstantRectGate rectifying_gate(
    redeclare function fn = reciprocalRatioFit(x0=0.59),
    c_ex = potassium.c_ex
  );
  // Note: R in mJ/(mol * K) -> R in J/(mol * K) by setting sx /= 1000
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  // Note: sx /= 1000 and sx *= 1000 cancel each other out => no change in sx
  InstantGate voltage_inact(
    redeclare function fn = generalizedLogisticFit(x0=V_eq-3.6e-3, sx=-1.393*FoRT),
    v = v
  ) "voltage-dependent inactivation (Lindblad1997)";
  // Note: mv -> V by setting x0 /= 1000 and sx *= 1000
  InstantGate voltage_act(
    redeclare function fn = generalizedLogisticFit(y_min=0.5, x0=-30e-3, sx=1000/5),
    v = v
  ) "voltage-dependent activation (only Inada 2009)";
equation
  if use_vact then
    open_ratio = rectifying_gate.n ^ 3 * voltage_inact.n * voltage_act.n;
  else
    open_ratio = rectifying_gate.n ^ 3 * voltage_inact.n;
  end if;
end InwardRectifier;
