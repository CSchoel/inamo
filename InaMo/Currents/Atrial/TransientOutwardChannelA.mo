within InaMo.Currents.Atrial;
model TransientOutwardChannelA "I_to for atrial cell model (Lindblad 1996)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max=20e-9);
  extends InaMo.Concentrations.Interfaces.TransmembraneKFlow;
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_to");
  extends Modelica.Icons.UnderConstruction;
  GateTS act(
    redeclare function ftau = pseudoABTau(
      redeclare function falpha = expFit(sx=1000/12, sy=386.6),
      redeclare function fbeta = expFit(sx=-1000/7.2, sy=8.011),
      off = 0.4e-3
    ),
    redeclare function fsteady = genLogistic(x0=-15e-3, sx=1000/5.633)
  );
  GateTS inact_fast(
    redeclare function ftau = genLogistic(y_min=0.0204, y_max=0.189+0.0204, x0=-32.8e-3, sx=-1000/0.1),
    redeclare function fsteady = inactFsteady
  );
  function inactFsteady = genLogistic(x0=-28.29e-3, sx=-1000/7.06);
  function customTauSlow
    function flog = genLogistic(y_max=5.750, x0=-32.8e-3, sx=-1000/0.1);
    function fnsqe = gaussianAmp(y_min=0.02, y_max=0.45+0.02, x0=13.54e-3, sigma=1/sqrt(2)*1/(-1000/13.97));
    input Real x;
    output Real y;
  algorithm
    y := flog(x) + fnsqe(x);
  end customTauSlow;
  GateTS inact_slow(
    redeclare function ftau = customTauSlow,
    redeclare function fsteady = inactFsteady
  );
  GateTS react_slow(
    redeclare function ftau = genLogistic(y_min=0.5, y_max=7.5+0.5, x0=-23e-3, sx=1000/0.5),
    redeclare function fsteady = genLogistic(y_min=0.666/1.666, y_max=(1+0.666)/1.666, x0=-50.67e-3, sx=-1000/27.38)
  );
  Real inact_total = (0.59 * inact_fast.n ^ 3 + 0.41 * inact_slow.n ^ 3) * (0.6 * react_slow.n ^ 3 + 0.4);
equation
  open_ratio = act.n * inact_total;
end TransientOutwardChannelA;
