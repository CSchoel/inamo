within InaMo.Concentrations.Atrioventricular;
model CaHandlingK "handling of Ca concentation by Kurata 2002"
  extends InaMo.Icons.SarcoplasmicReticulum;
  parameter SI.Concentration tc_tot = 0.031 "total concentration of troponin-Ca";
  parameter SI.Concentration tmc_tot = 0.062 "total concentration of troponin-Mg binding to Ca2+";
  parameter SI.Concentration cm_tot = 0.045 "total concentration of calmodulin";
  parameter SI.Concentration cq_tot = 10 "total concentration of calsequestrin";
  outer parameter SI.Volume v_sub "volume of subspace";
  outer parameter SI.Volume v_cyto "volume of cytosol";
  outer parameter SI.Volume v_nsr "volume of network SR";
  outer parameter SI.Volume v_jsr "volume of junctional SR";
  InaMo.Concentrations.Interfaces.CalciumSite ca_sub
    "connector exposing Ca2+ in subspace to external influences by membrane currents"
    annotation(Placement(transformation(origin = {-100, 0}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.ConstantConcentration mg(
    c_const=2.5, vol=v_cyto,
    redeclare connector SubstanceSite = MagnesiumSite
  ) "Mg2+ concentration" annotation(Placement(transformation(origin = {80, -26}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Compartment sub(vol=v_sub) "Ca2+ in subspace" annotation(Placement(transformation(origin = {-86, 82}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Compartment cyto(vol=v_cyto) "Ca2+ in cytosol" annotation(Placement(transformation(origin = {20, -28}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Compartment jsr(vol=v_jsr) "Ca2+ in JSR" annotation(Placement(transformation(origin = {-16, 70}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Compartment nsr(vol=v_nsr) "Ca2+ in NSR" annotation(Placement(transformation(origin = {62, 54}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Diffusion sub_cyto(vol_src=sub.vol, vol_dst=cyto.vol, tau=0.04e-3)
    "diffusion from subspace to cytosol" // tau = tau_diff,Ca
    annotation(Placement(transformation(origin = {-58, -38}, extent = {{17, -17}, {-17, 17}}, rotation = -90)));
  InaMo.Concentrations.Atrioventricular.SERCAPump cyto_nsr(vol_src=cyto.vol, p=0.005e3*v_nsr, k=0.0006)
    "transport from cytosol to NSR via SERCA" // p = P_up, k = K_up
    annotation(Placement(transformation(origin = {48, 12}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Diffusion nsr_jsr(vol_src=nsr.vol, vol_dst=jsr.vol, tau=60e-3)
    "diffusion from NSR to JSR" // tau = tau_tr
    annotation(Placement(transformation(origin = {16, 42}, extent = {{-17, -17}, {17, 17}}, rotation = 90)));
  InaMo.Concentrations.Atrioventricular.RyanodineReceptor jsr_sub(vol_src=jsr.vol, vol_dst=sub.vol, p=5e3, ka=0.0012, n=2)
    "transport from JSR to subspace via RyR" // p = P_rel, k = K_rel
    annotation(Placement(transformation(origin = {-50, 62}, extent = {{-17, -17}, {17, 17}}, rotation = 90)));
  InaMo.Concentrations.Basic.Buffer tc(n_tot=tc_tot*v_cyto, k=88.8e3/v_cyto, kb=0.446e3) "troponin-Ca"
    annotation(Placement(transformation(origin = {-36, -74}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Buffer2p tm(
    n_tot=tmc_tot*v_cyto, vol=v_cyto,
    k_a=227.7e3/v_cyto, kb_a=0.00751e3,
    k_b=2.277e3/v_cyto, kb_b=0.751e3,
    redeclare connector SubstanceSiteB = MagnesiumSite
  ) "troponin-mg"
    annotation(Placement(transformation(origin = {46, -72}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Buffer cm_cyto(n_tot=cm_tot*v_cyto, k=227.7e3/v_cyto, kb=0.542e3) "calmodulin in cytosol" annotation(Placement(transformation(origin = {4, -74}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Buffer cm_sub(n_tot=cm_tot*v_sub, k=cm_cyto.k*v_cyto/v_sub, kb=cm_cyto.kb) "calmodulin in subspace" annotation(Placement(transformation(origin = {-74, 28}, extent = {{-17, -17}, {17, 17}})));
  InaMo.Concentrations.Basic.Buffer cq(n_tot=cq_tot*v_jsr, k=0.534e3/v_jsr, kb=0.445e3) "calsequestrin"
    annotation(Placement(transformation(origin = {-18, 18}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(sub.substance, ca_sub) annotation(
    Line(points = {{-86, 66}, {-96, 66}, {-96, 0}, {-100, 0}}));
  connect(ca_sub, sub_cyto.src) annotation(
    Line(points = {{-100, 0}, {-96, 0}, {-96, -38}, {-74, -38}, {-74, -38}}));
  connect(sub_cyto.dst, cyto.substance) annotation(
    Line(points = {{-40, -38}, {0, -38}, {0, -44}, {20, -44}, {20, -44}}));
  connect(cyto.substance, cyto_nsr.src) annotation(
    Line(points = {{20, -44}, {48, -44}, {48, -4}, {48, -4}}));
  connect(cyto_nsr.dst, nsr.substance) annotation(
    Line(points = {{48, 30}, {62, 30}, {62, 38}, {62, 38}}));
  connect(nsr.substance, nsr_jsr.src) annotation(
    Line(points = {{62, 38}, {40, 38}, {40, 42}, {34, 42}, {34, 42}}));
  connect(nsr_jsr.dst, jsr.substance) annotation(
    Line(points = {{0, 42}, {-16, 42}, {-16, 54}, {-16, 54}}));
  connect(jsr.substance, jsr_sub.src) annotation(
    Line(points = {{-16, 54}, {-32, 54}, {-32, 62}, {-32, 62}}));
  connect(jsr_sub.dst, sub.substance) annotation(
    Line(points = {{-66, 62}, {-86, 62}, {-86, 66}, {-86, 66}}));
  connect(tc.site, cyto.substance) annotation(
    Line(points = {{-40, -62}, {-40, -62}, {-40, -48}, {20, -48}, {20, -44}}));
  connect(tm.site_a, cyto.substance) annotation(
    Line(points = {{38, -60}, {38, -48}, {20, -48}, {20, -44}}));
  connect(tm.site_b, mg.substance) annotation(
    Line(points = {{64, -54}, {62, -54}, {62, -48}, {80, -48}, {80, -42}}));
  connect(cm_cyto.site, cyto.substance) annotation(
    Line(points = {{0, -62}, {0, -48}, {20, -48}, {20, -44}}));
  connect(sub.substance, cm_sub.site) annotation(
    Line(points = {{-86, 66}, {-86, 66}, {-86, 48}, {-78, 48}, {-78, 40}, {-78, 40}}));
  connect(jsr.substance, cq.site) annotation(
    Line(points = {{-16, 54}, {-16, 54}, {-16, 30}, {-22, 30}, {-22, 30}}));
annotation(
  Documentation(info="<html>
    <p>Kurata et al. model the intracellular calcium concentration based on
    four compartments:</p>
    <ul>
      <li>the cytoplasm (cyto)</li>
      <li>the junctional sarcoplasmic reticulum (JSR)</li>
      <li>the network sarcoplasmic reticulum (NSR)</li>
      <li>the &quot;subspace&quot; subspace (sub), i.e. the &quot;functionally
      restricted intracellular space accessible to the NaCa exchanger as well
      as to the L-type Ca2+ channel and the Ca2+-gated Ca2+ channel in the SR.
      </li>
    </ul>
    <p>The model includes the transfer between these compartments by
    diffusion reactions (cytoplasm <-> subspace and JSR <-> NSR), the uptake
    of Ca2+ in the SR via the SERCA pump, and the release of Ca2+ from the
    SR via the ryanodine receptors.
    Additionally, the effect of several Ca2+ buffers is modeled:</p>
    <ul>
      <li>troponin-Ca</li>
      <li>troponin-Mg</li>
      <li>calmodulin (in subspace and cytosol)</li>
      <li>calsequestrin</li>
    </ul>
  </html>"),
  Diagram(
    graphics = {
      Polygon(
        origin = {12, 0},
        fillColor = {213, 213, 213},
        pattern = LinePattern.None,
        fillPattern = FillPattern.Solid,
        points = {{-68, -100}, {-70, -74}, {-70, -54}, {-70, -16}, {-62, 8}, {-66, 100}, {-44, 100}, {88, 100}, {88, 100}, {88, -100}, {88, -100}, {-51, -100}, {-68, -100}},
        smooth = Smooth.Bezier
      ),
      Polygon(
        origin = {-90, 142},
        points = {{171.31, -71}, {157.99, -71}, {115.86, -71}, {105.58, -71}, {105.58, -49.41}, {40.28, -49.41}, {40.28, -77}, {40.28, -121}, {40.28, -148.59}, {103.58, -148.59}, {103.58, -129}, {115.86, -129}, {157.99, -129}, {171.31, -129}, {171.31, -108}, {171.31, -92}, {171.31, -71}},
        smooth = Smooth.Bezier
      )
    }
  )
);
end CaHandlingK;
