within InaMo.Components.IonConcentrations;
model TransmembraneKFlow
  extends InaMo.Components.IonConcentrations.EITransportConst(
    trans(n=n_k, z=1),
    con.c_const = k_ex
  );
  PotassiumSite k
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_k = 1;
  outer parameter SI.Concentration k_ex "extracellular concentration of Ca2+ ions";
equation
  connect(k, trans.src);
end TransmembraneKFlow;
