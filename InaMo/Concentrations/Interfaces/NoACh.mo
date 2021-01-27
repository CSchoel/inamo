within InaMo.Concentrations.Interfaces;
partial model NoACh "model used to set all parameters required to deactivate ACh influence"
  inner parameter Boolean use_ach = false;
  inner parameter SI.Concentration ach = 0;
end NoACh;
