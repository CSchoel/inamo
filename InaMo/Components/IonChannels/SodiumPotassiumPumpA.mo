within InaMo.Components.IonChannels;
model SodiumPotassiumPumpA "I_NaK for atrial cell model (Lindblad 1996)"
  extends OnePortVertical;
  extends NaFlux(n_na=3, vol_na=v_cyto);
  extends KFlux(n_k=-2, vol_k=v_cyto);
  extends InaMo.Icons.IonChannel;
  extends InaMo.Icons.SodiumPotassiumPump;
  extends InaMo.Icons.Current(current_name="I_NaK");
  inner SI.Current i_ion = i;
  outer parameter SI.Volume v_cyto;
  outer parameter SI.Concentration k_ex;
  parameter SI.Current i_max = 0.16e-9;
  parameter SI.Concentration k_m_Na = 5.64;
  parameter SI.Concentration k_m_K = 0.621;
equation
  i = i_max * michaelisMenten(k_ex, k_m_K) * hillLangmuir(na.c, k_m_Na, 1.5) * (v + 150e-3) / (v + 200e-3);
end SodiumPotassiumPumpA;
