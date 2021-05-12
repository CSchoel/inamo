model CaHandling "extension of Ca handling by Inaada 2009"
  extends CaHandlingK;
  parameter SI.Concentration cm_sl_tot = 0.031 / 1.2 "total concentration of calmodulin in sarcolemma";
  InaMo.Concentrations.Basic.Buffer cm_sl(n_tot = cm_sl_tot * v_sub, k = 0.115e3 / v_sub, kb = 1e3) "calmodulin in sarcolemma" annotation(
    Placement(transformation(origin = {-82, -78}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(cm_sl.site, sub.substance) annotation(
    Line(points = {{-86, -66}, {-86, -66}, {-86, -56}, {-96, -56}, {-96, 0}, {-100, 0}}));
  annotation(
    Documentation(info = "<html>
  <p>This model is an extension to the Ca2+ handling in Kurata 2002 by Inada
  et al..
  It includes an additional calmodulin concentration in the sarcolemma.</p>
  <p>NOTE: Unfortunately, the total value of this concentration (cm_sl_tot) is not
  given in Inada et al. (where it is called SL_tot).
  In the C++ implementation by Inada et al., cm_sl_tot has a value of
  31/1.2 mM (av_node_2.cpp:508), which seems to be the wrong order of magnitude
  compared to, the other calmodulin concentrations which use a total
  concentration of 0.045 mM.
  This is probably the reason why the C++ code multiplies the whole equation
  for der(cm_sl.f) with 0.0001, effectively reducing cm_sl.k and cm_sl.kb and
  thus cancelling out the increase in cm_sl_tot by the same factor.
  The CellML version attempts to correct the value for cm_sl_tot, but keeps
  the already corrected values for cm_sl.k and cm_sl.kb, effectively
  introducing an error.
  In InaMo, we use a reduced cm_sl_tot, but also increase cm_sl.k and cm_sl.kb
  accordingly to achieve the same numerical result as the C++ code.</p>
</html>"));
end CaHandling;