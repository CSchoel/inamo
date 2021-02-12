model LTypeCalciumChannelN "L-type calcium channel (I_Ca,L) for N-type cells"
  extends LTypeCalciumChannel(act(redeclare function fsteady = genLogistic(x0 = -18.2e-3, sx = 1000 / 5)));
  annotation(
    Documentation(info = "<html>
  <p>This is a slight variation of I_Ca,L used for N-type cells.
  It only exchanges the equation for the steady state of the activation gate.
  </p>
</html>"));
end LTypeCalciumChannelN;