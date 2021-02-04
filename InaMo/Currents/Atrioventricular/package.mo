within InaMo.Currents;
package Atrioventricular "currents in atrioventricular cells"
  import InaMo.Currents.Basic.GateAB;
  import InaMo.Currents.Basic.GateTS;
  import InaMo.Currents.Basic.GateTSShift;
  import InaMo.Currents.Basic.InstantGate;
  extends Modelica.Icons.Package;
annotation(
  Icon(
    graphics = {
      Text(extent={{-90,-90}, {-30,90}}, textString="A"),
      Text(extent={{-30,-90}, {30,90}}, textString="V"),
      Text(extent={{30,-90}, {90,90}}, textString="N")
    }
  )
);
end Atrioventricular;
