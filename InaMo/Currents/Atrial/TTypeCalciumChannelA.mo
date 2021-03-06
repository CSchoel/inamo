within InaMo.Currents.Atrial;
model TTypeCalciumChannelA "I_Ca,T for atrial model (Lindblad 1996)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max=18.5e-9, v_eq=62.1e-3);
  extends InaMo.Concentrations.Interfaces.TransmembraneCaFlow;
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_Ca,T");
  extends Modelica.Icons.UnderConstruction;
  GateAB act(
    redeclare function falpha = expFit(x0=-23e-3, sx=1000/30, sy=674.173),
    redeclare function fbeta = expFit(x0=-23e-3, sx=-1000/30, sy=674.173)
  );
  GateAB inact(
    redeclare function falpha = expFit(x0=-75e-3, sx=-1000/83.333, sy=9.637),
    redeclare function fbeta = expFit(x0=-75e-3, sx=1000/15.385, sy=9.637)
  );
equation
  open_ratio = act.n * inact.n;
end TTypeCalciumChannelA;
