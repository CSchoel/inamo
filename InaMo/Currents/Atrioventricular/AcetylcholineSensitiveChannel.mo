within InaMo.Currents.Atrioventricular;
model AcetylcholineSensitiveChannel "acetylcholine sensitive potassium channel (I_ACh) as found in the C++ implementation of Inada 2009"
  extends IonChannelElectric(g_max=g_ach * g_k);
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
  outer parameter SI.Concentration k_ex;
  outer parameter SI.Concentration ach;
  parameter Real g_ach = hillLangmuir(ach, k_ach, 1.5);
  parameter Real g_k = michaelisMenten(k_ex, 10);
  inner parameter Real FoRT = Modelica.Constants.F / (Modelica.Constants.R * temp);
  GateAB inact_fast(
    redeclare function falpha = constValue(c=73.1),
    redeclare function fbeta = genLogistic(y_max=120, x0=-50e-3, sx=1000/15)
  );
  GateAB inact_slow(
    redeclare function falpha = constValue(c=3.7),
    redeclare function fbeta = genLogistic(y_max=5.82, x0=-50e-3, sx=1000/15)
  );
  InstantGate act(
    redeclare function fn = genLogistic(x0=v_eq + 140e-3, sx=FoRT/2.5)
  );
equation
  open_ratio = act.n * inact_slow.n * inact_fast.n;
annotation(Documentation(info="<html>
  <p>This channel formulation is found in the C++ implementation by
  Inada et al., but not in the article.
  We are not aware of any scientific publication that describes I_ACh with
  these precise equations and therefore there is also no reference plot
  available.</p>
  <p>We can only speculate that Inada et al. probably experimented with
  including this current but ultimately chose not to.
  Our models therefore also by default disable this current.</p>
</html>"));
end AcetylcholineSensitiveChannel;
