within InaMo.Components.IonCurrents;
model LTypeCalciumChannelA "I_Ca,L for atrial model (Lindblad 1996)"
  extends IonChannelElectric(g_max=18.5e-9, v_eq=62.1e-3);
  extends TransmembraneCaFlow(n_ca=1);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name="I_Ca,L");
  extends Modelica.Icons.UnderConstruction;
  GateAB act(
    redeclare function falpha = fsum(
      redeclare function fa = goldmanFit(x0=-35e-3, sx=-1000/2.5, sy=16.72*2.5),
      redeclare function fb = goldmanFit(sx=-1000/4.808, sy=50*4.808)
    ),
    redeclare function fbeta = goldmanFit(x0=5e-3, sx=0.4e3, sy=4.480/0.4)
  );
  GateTS inact(
    redeclare function ftau = negSquaredExpFit(y_min=0.015, y_max=0.211+0.015, x0=-37.427e-3, sx=1000/20.213),
    redeclare function fsteady = pseudoABSteady(
      redeclare function falpha = goldmanFit(x0=-28e-3, sx=1000/4, sy=8.49*4),
      redeclare function fbeta = generalizedLogisticFit(y_max=67.922, x0=-28e-3, sx=1000/4)
    )
  );
  InstantGate noninact(
    redeclare function fn = generalizedLogisticFit(x0=33e-3, sx=1/12)
  ) "noninactivating factor to account for Ca2+ dependence of I_Ca,L inactivation";
equation
  open_ratio = act.n * inact.n + noninact.n;
end LTypeCalciumChannelA;
