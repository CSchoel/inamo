within InaMo.Currents.Basic;
model GateTS "gating molecule with two conformations/positions X and Y governed by two functions tau and steady"
  extends InaMo.Icons.Gate;
  import InaMo.Functions.Fitting.*;
  replaceable function ftau = genLogistic "time constant for obtaining steady state (i.e. time until difference between n and steady has reduced by a factor of 1/e)";
  replaceable function fsteady = genLogistic "value that n would reach if v_gate was held constant";
  Real n(start=fsteady(0), fixed=true) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential of enclosing component";
  Real steady = fsteady(v_gate) "value that n would reach if v_gate was held constant";
  SI.Duration tau = ftau(v_gate) "time constant for obtaining steady state (i.e. time until difference between n and steady has reduced by a factor of 1/e)";
equation
  der(n) = (steady - n) / tau;
annotation(
Documentation(info="<html>
    <p>This model reprensents a gate in a Hodgkin-Huxley-style ion channel.</p>
    <p>To define a specific gate, the fitting functions <code>fsteady</code>
    and <code>ftau</code> have to be redeclared in the ion channel model where
    the gate is used.
    This can be achieved using the redeclare mechanism in Modelica as follows:
    </p>
    <pre>
    GateAB activation(
      redeclare function fsteady = myFancyFittingFunction(p1=1, p2=2, ...),
      redeclare function ftau = myFancyFittingFunction(p1=3, p2=4, ...)
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
  Icon(graphics = {Text(origin = {-1, -41}, extent = {{-29, 31}, {29, -31}}, textString = "τ/∞")})
);
end GateTS;
