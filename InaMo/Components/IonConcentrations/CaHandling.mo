within InaMo.Components.IonConcentrations;
model CaHandling "extension of Ca handling by Inaada 2009"
  extends CaHandlingK;
  // NOTE: no value is given for cm_sl.c_tot in Inada 2009 (SL_tot)
  //       => value taken from code (av_node_2.cpp:508)
  // NOTE: cm_sl.c is reduced by a factor of 1/1000 in CellML w.r.t. C++
  //       this seems like a mistake since it would render the influence
  //       of cm_sl negligible
  // NOTE: cm_sl.c of the C++ model is by an order of magnitude higher than
  //       total concentration of other buffers and cm_sl.k and cm_sl.kb are
  //       an order of magnitude lower => we multiply c_tot by 1/1000 and
  //       k and kb by 1000
  parameter SI.Concentration cm_sl_tot = 0.031/1.2 "total concentration of calmodulin in sarcolemma";
  Buffer cm_sl(n_tot=cm_sl_tot*v_sub, k=0.115e3, kb=1e3) "calmodulin in sarcolemma"
    annotation(Placement(transformation(origin = {-82, -78}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(cm_sl.site, sub.c) annotation(
    Line(points = {{-86, -66}, {-86, -66}, {-86, -56}, {-96, -56}, {-96, 0}, {-100, 0}}));
end CaHandling;
