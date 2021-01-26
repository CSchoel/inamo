within InaMo.Components.Cells;
model ACell "full atrial cell model following equations from Lindblad et al. (1996)"
  extends Modelica.Icons.UnderConstruction;
  extends InaMo.Interfaces.TwoPinCell;
  inner parameter SI.Volume v_ca = 1 "volume of comparment from which Ca2+ is transported across the cell membrane"; // FIXME unsure if this naming is correct
  inner parameter SI.Volume v_cyto = 1 "volume of cytosol";
  inner parameter SI.Volume v_nsr = 1 "volume of network sarcoplasmic reticulum";
  inner parameter SI.Volume v_jsr = 1 "volume of junctional sarcoplasmic reticulum";
  inner parameter SI.Temperature temp = 310 "temperature of cell medium";
  inner parameter SI.Concentration ca_ex = 1 "extracellular calcium concentration";
  inner parameter SI.Concentration na_ex = 1 "extracellular sodium concentration";
  inner parameter SI.Concentration k_ex = 1 "extracellular potassium concentration";
  inner parameter PermeabilityFM na_p = 1 "permeability of cell membrane for sodium";
  inner parameter Real FoRT = 1 "result of F/(R*T)";
  SodiumChannelA na "I_Na";
  LTypeCalciumChannelA cal "I_Ca,L";
  TTypeCalciumChannelA cat "I_Ca,T";
  TransientOutwardChannelA to "I_to";
  RapidDelayedRectifierChannelA kr "I_K,r";
  SlowDelayedRectifierChannelA ks "I_K,s";
  InwardRectifierA kir "I_K1";
  BackgroundChannelNa bna "I_B,Na";
  BackgroundChannelCa bca "I_B,Ca";
  BackgroundChannelCl bcl "I_B,Cl";
  CalciumPump cap "I_CaP";
  SodiumPotassiumPumpA nak "I_NaK";
  SodiumCalciumExchangerA naca "I_NaCa";
  Compartment na_in "intracellular sodium";
  Compartment k_in "intracellular potassium";
  CaHandlingA ca(v_m=l2.v) "intracellular Ca2+ handling by SR and buffers";
  LipidBilayer l2 "membrane as capacitor";
equation
  connect(l2.p, p);
  connect(l2.n, n);
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, cat.p);
  connect(l2.n, cat.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
  connect(l2.p, ks.p);
  connect(l2.n, ks.n);
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, bna.p);
  connect(l2.n, bna.n);
  connect(l2.p, bca.p);
  connect(l2.n, bca.n);
  connect(l2.p, bcl.p);
  connect(l2.n, bcl.n);
  connect(l2.p, cap.p);
  connect(l2.n, cap.n);
  connect(l2.p, nak.p);
  connect(l2.n, nak.n);
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  connect(ca.ca_cyto, cal.ca);
  connect(ca.ca_cyto, cat.ca);
  connect(ca.ca_cyto, bca.ca);
  connect(ca.ca_cyto, cap.ca);
  connect(ca.ca_cyto, naca.ca);
  connect(na_in.substance, na.na);
  connect(na_in.substance, bna.na);
  connect(na_in.substance, nak.na);
  connect(na_in.substance, naca.na);
  connect(k_in.substance, to.k);
  connect(k_in.substance, kr.k);
  connect(k_in.substance, ks.k);
  connect(k_in.substance, kir.k);
  connect(k_in.substance, nak.k);
annotation(Documentation(info="<html>
  <p>
    This model represents a rabbit atrial muscle cell with equations by
    Lindblad et al. (1996).
    It is used by Inada et al. in their full 1D-model of the rabbit
    atrioventricular node as &quot;AM&quot; cell type along with the sinoatrial node
    cells SAN by Zhang et al. (2000) and their own AN, N, and NH cell models.
  </p>
  <p>
    NOTE: Currently this model can be compiled, but not simulated, since our
    focus was on the AN, N, and NH cell types.
  </p>
</html>"));
end ACell;
