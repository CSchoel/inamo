within InaMo.Components.IonCurrents;
model AcetylcholineSensitiveChannel "I_ACh"
  extends GatedIonChannel(g_max=g_ach * g_k);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_ACh");
  function constValue
    input Real x;
    input Real c = 0;
    output Real y;
  algorithm
    y := c;
  end constValue;
  parameter SI.Concentration k_ach = 3.5e-7;
  outer parameter SI.Temperature temp;
  outer parameter SI.Concentration k_out;
  outer parameter SI.Concentration ach;
  parameter Real g_ach = hillLangmuir(ach, k_ach, 1.5);
  parameter Real g_k = michaelisMenten(k_out, 10);
  inner parameter Real FoRT = Modelica.Constants.F / (Modelica.Constants.R * temp);
  GateAB inact_fast(
    redeclare function falpha = constValue(c=73.1),
    redeclare function fbeta = generalizedLogisticFit(y_max=120, x0=-50e-3, sx=1000/15)
  );
  GateAB inact_slow(
    redeclare function falpha = constValue(c=3.7),
    redeclare function fbeta = generalizedLogisticFit(y_max=5.82, x0=-50e-3, sx=1000/15)
  );
  InstantGate act(
    redeclare function fn = generalizedLogisticFit(x0=v_eq + 140e-3, sx=FoRT/2.5)
  );
equation
  open_ratio = act.n * inact_slow.n * inact_fast.n;
end AcetylcholineSensitiveChannel;
