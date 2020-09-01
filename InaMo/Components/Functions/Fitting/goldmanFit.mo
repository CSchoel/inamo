within InaMo.Components.Functions.Fitting;
function goldmanFit "fitting function related to Goldmans formula for the movement of a charged particle in a constant electrical field"
  extends Modelica.Icons.Function;
  input Real x "input value";
  input Real x0 = 0 "offset for x (fitting parameter)";
  input Real sy = 1 "scaling factor for y (fitting parameter)";
  input Real sx = 1 "scaling factor for x (fitting parameter)";
  output Real y "result";
protected
  Real x_adj "adjusted x with offset and scaling factor";
algorithm
  x_adj := sx * (x - x0);
  if abs(x - x0) < 1e-6 then
    y := sy; // using L'Hôpital to find limit for x_adj->0
  else
    y := sy * x_adj / (exp(x_adj) - 1);
  end if;
  annotation(
    Documentation(info="
      <html>
        <p>Hodgkin and Huxley state that this formula was (in part) used
        because it &quot;bears a close resemblance to the equation derived
        by Goldman (1943) for the movements of a charged particle in a constant
        field&quot;.</p>
        <p>We suppose that this statement refers to equation 11 of Goldman
        (1943) when n_i' is zero.</p>
      </html>
    ")
  );
end goldmanFit;
