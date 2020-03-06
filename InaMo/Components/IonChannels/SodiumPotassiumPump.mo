within InaMo.Components.IonChannels;
model SodiumPotassiumPump
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  input MobileIon sodium;
  input MobileIon potassium;
  parameter SI.Current i_max = 1;
  parameter SI.Concentration K_m_Na = 1;
  parameter SI.Concentration K_m_K = 1;
equation
  i = i_max * reciprocalRatioFit(sodium.c_in, x0=K_m_Na) ^ 3 * reciprocalRatioFit(potassium.c_ex, x0=K_m_K) ^ 2 * generalizedLogisticFit(v, x0 = -0.06, sx=1000/40, d_off=1.5);
end SodiumPotassiumPump;
