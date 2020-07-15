within InaMo.Components.IonChannels;
model SodiumPotassiumPumpA "I_NaK for atrial cell model (Lindblad 1996)"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  outer parameter SI.Concentration na_in, k_ex;
  parameter SI.Current i_max = 0.16e-9;
  parameter SI.Concentration k_m_Na = 5.64;
  parameter SI.Concentration k_m_K = 0.621;
equation
  i = i_max * michaelisMenten(k_ex, k_m_K) * hillLangmuir(na_in, k_m_Na, 1.5) * (v + 150e-3) / (v + 200e-3);
end SodiumPotassiumPumpA;