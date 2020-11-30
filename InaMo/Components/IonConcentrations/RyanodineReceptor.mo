within InaMo.Components.IonConcentrations;
model RyanodineReceptor "diffusion following Hill-Langmuir kinetics"
  extends InactiveChemicalTransport;
  parameter Real p(quantity="reaction rate coefficient", unit="1/s") "rate coefficient (inverse of time constant)";
  parameter SI.Concentration ka "concentration producing half occupation";
  parameter Real n(unit="1") "Hill coefficient";
equation
  coeff = p * hillLangmuir(dst.amount / vol_dst, ka, n);
annotation(
  Icon(graphics = {
    Text(origin = {-33, 30}, extent = {{-3, 14}, {31, -22}}, textString = "HL")
  })
);
end RyanodineReceptor;