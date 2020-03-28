within InaMo.Examples;
model SustainedInwardIVKurata "try tro recreate figure 2 B from lindblad 1997"
  extends SustainedInwardIV(
    st(
      act(
        redeclare function fsteady = generalizedLogisticFit(x0=-57e-3, sx=1000/5)
      ),
      G_max=0.48e-9
    ),
    l2(
      C=32e-12
    )
  );
end SustainedInwardIVKurata;
