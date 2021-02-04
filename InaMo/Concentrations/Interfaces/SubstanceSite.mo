within InaMo.Concentrations.Interfaces;
model SubstanceSite "general connector for transferring substances"
  SI.AmountOfSubstance amount(nominal=1e-21) "amount of substance";
  flow SI.MolarFlowRate rate(nominal=1e-17) "molar flow rate of substance";
annotation(
  Icon(
    graphics={
      Ellipse(
        origin={0,0}, extent={{-100,-100},{100,100}},
        fillColor = {145, 204, 255},
        fillPattern = FillPattern.Solid
      )
    }
  )
);
end SubstanceSite;
