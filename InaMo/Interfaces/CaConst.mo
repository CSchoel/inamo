within InaMo.Interfaces;
partial model CaConst "model used to set all parameters required to keep intracellular Ca2+ constant"
  inner parameter Boolean ca_const = true;
  inner parameter SI.Volume v_sub = 1;
end CaConst;
