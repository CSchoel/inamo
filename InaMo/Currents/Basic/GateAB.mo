within InaMo.Currents.Basic;
model GateAB "gating molecule with an open and a closed conformation governed by two functions alpha and beta"
  extends InaMo.Icons.Gate;
  import InaMo.Functions.Fitting.*;
  replaceable function falpha = goldman(x0=0, sx=1, sy=1) "rate of transfer from closed to open conformation";
  replaceable function fbeta = expFit(x0=0, sx=1, sy=1) "rate of transfer from open to closed conformation";
  Real n(start=falpha(0)/(falpha(0) + fbeta(0)), fixed=true) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential of enclosing component";
  Real alpha(unit="1") = falpha(v_gate) "rate of transfer from closed to open conformation";
  Real beta(unit="1") = fbeta(v_gate) "rate of transfer from open to closed conformation";
  Real steady(unit="1") = alpha / (alpha + beta) "steady state achieved if current voltage is held constant";
  SI.Duration tau = 1 / (alpha + beta) "time constant for obtaining steady state (i.e. time until difference between n and steady has reduced by a factor of 1/e)";
equation
  der(n) = alpha * (1 - n) - beta * n;
annotation(
  Documentation(info="<html>
    <p>This model reprensents a gate in a Hodgkin-Huxley-style ion channel.</p>
    <p>To define a specific gate, the fitting functions <code>falpha</code>
    and <code>fbeta</code> have to be redeclared in the ion channel model where
    the gate is used.
    This can be achieved using the redeclare mechanism in Modelica as follows:
    </p>
    <pre>
    GateAB activation(
      redeclare function falpha = myFancyFittingFunction(p1=1, p2=2, ...),
      redeclare function fbeta = myFancyFittingFunction(p1=3, p2=4, ...)
    );
    inner SI.ElectricPotential v_gate = myVoltageVariable;
    </pre>
    <p>Note that you only have to supply <code>v_gate</code> once, since
    it is automatically connected to any components which define a
    <code>outer</code> variable with the same name.
    If you use the base class InaMo.Currents.Interfaces.GatedIonChannel,
    you even do not have to supply this variable at all, as it is already
    defined in the base class.</p>
  </html>"),
  Icon(graphics = {Text(origin = {-1, -41}, extent = {{-29, 31}, {29, -31}}, textString = "α/β")})
);
end GateAB;
