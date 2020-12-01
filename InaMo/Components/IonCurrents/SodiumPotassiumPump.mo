within InaMo.Components.IonCurrents;
model SodiumPotassiumPump
  extends OnePortVertical;
  extends InaMo.Icons.LipidBilayerWithGap;
  extends InaMo.Icons.SodiumPotassiumPump;
  extends InaMo.Icons.Current(current_name="I_NaK");

  outer parameter SI.Concentration na_in, k_ex;
  parameter SI.Current i_max = 24.6e-12; // taken from Inada 2009, S15
  parameter SI.Concentration k_m_Na = 5.64; // taken from Zhang 2000, not given in Inada 2009
  parameter SI.Concentration k_m_K = 0.621; // taken from Zhang 2000, not given in Inada 2009
equation
  i = i_max * michaelisMenten(na_in, k_m_Na) ^ 3 * michaelisMenten(k_ex, k_m_K) ^ 2 * generalizedLogisticFit(v, y_max=1.6, x0 = -0.06, sx=1000/40, d_off=1.5);
end SodiumPotassiumPump;
