within InaMo.Concentrations.Interfaces;
partial model CaConst "model used to set all parameters required to keep intracellular Ca2+ constant"
  inner parameter SI.Volume v_sub = 1;
annotation(Documentation(info="<html>
  <p>Although this model only contains a single inner parameter definition,
  its name makes its use more intuitive than copying said parameter definition
  into all models that need it.</p>
</html>"));
end CaConst;
