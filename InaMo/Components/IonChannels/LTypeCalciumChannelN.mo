within InaMo.Components.IonChannels;
model LTypeCalciumChannelN "I_Ca,L for N-type cells"
  extends LTypeCalciumChannel(act(
    redeclare function fsteady = generalizedLogisticFit(x0=-18.2e-3, sx=1000/5)
  ));
end LTypeCalciumChannelN;
