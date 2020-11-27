within InaMo.Components.IonConcentrations;
model TransmembraneNaFlow
  extends InaMo.Components.IonConcentrations.EITransportConst(
    trans(n=n_na, z=1),
    con.c_const = na_ex
  );
  SodiumSite k
    annotation(Placement(visible=true, transformation(origin = {35, -100}, extent = {{-17, -17}, {17, 17}})));
  parameter Real n_na = 1;
  outer parameter SI.Concentration na_ex "extracellular concentration of Na+ ions";
equation
  connect(k, trans.src);
end TransmembraneNaFlow;
