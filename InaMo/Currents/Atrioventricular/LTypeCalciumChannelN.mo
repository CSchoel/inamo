within InaMo.Currents.Atrioventricular;
model LTypeCalciumChannelN "I_Ca,L for N-type cells"
  extends LTypeCalciumChannel(act(
    redeclare function fsteady = genLogistic(x0=-18.2e-3, sx=1000/5)
  ));
end LTypeCalciumChannelN;
