within InaMo.Concentrations.Interfaces;
model TransmembraneKFlow
  extends InaMo.Concentrations.Interfaces.EITransportConst(
    trans(n=n_k, z=1),
    con.c_const = k_ex
  );
  PotassiumSite k
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_k = 1;
  outer parameter SI.Concentration k_ex "extracellular concentration of K+ ions";
equation
  connect(k, trans.src);
end TransmembraneKFlow;
