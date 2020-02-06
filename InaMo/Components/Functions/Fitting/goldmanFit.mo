within InaMo.Components.Functions.Fitting;
// TODO rename fitting parameters in accordance to other fitting functions
function goldmanFit "fitting function related to Goldmans formula for the movement of a charged particle in a constant electrical field"
  input Real V "membrane potential (as displacement from resting potential)";
  input Real V_off = 0 "offset for V (fitting parameter)";
  input Real sdn = 1 "scaling factor for dn (fitting parameter)";
  input Real sV = 1 "scaling factor for V (fitting parameter)";
  output Real dn "rate of change of the gating variable at given V";
protected
  Real V_adj "adjusted V with offset and scaling factor";
algorithm
  V_adj := sV * (V + V_off);
  if V_adj == 0 then
    dn := sV; // using L'Hôpital to find limit for V_adj->0
  else
    dn := sdn * V_adj / (exp(V_adj) - 1);
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
