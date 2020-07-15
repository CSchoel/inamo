within InaMo.Components;
package IonConcentrations
  import InaMo.Components.Functions.*;
  import InaMo.Components.Connectors.*;
  model ConstantConcentration "ion concentration with constant value"
    IonConcentration c;
    parameter SI.Concentration c_const = 1 "fixed concentration";
  equation
    c.c = c_const;
  end ConstantConcentration;
  model Compartment "compartment that has an ion concentration"
    IonConcentration c;
    parameter SI.Volume vol "volume of the compartment";
    parameter SI.Concentration c_start = 1 "initial value of concentration";
  initial equation
    c.c = c_start;
  equation
    der(c.c) = c.rate;
  end Compartment;
  partial model Diffusion "base model for diffusion reactions"
    IonConcentration dst "destination of diffusion (for positive sign)";
    IonConcentration src "source of diffusion (for positive sign)";
    Real j(unit="mol/(m3.s)") "rate of change in concentration (~= diffusion flux)";
    parameter SI.Volume v_dst = 1 "volume of the destination compartment";
    parameter SI.Volume v_src = 1 "volume of the source compartment";
    parameter Boolean flip = false "if true, volume ratio is applied to destination rate instead of source rate";
  equation
    if flip then
      dst.rate = -j * v_src / v_dst;
      src.rate = j;
    else
      dst.rate = -j;
      src.rate = j * v_dst / v_src;
    end if;
  end Diffusion;
  model DiffSimple "simple linear diffusion with time constant"
    extends Diffusion;
    parameter SI.Duration tau "time constant of diffusion";
  equation
    j = (src.c - dst.c) / tau;
  end DiffSimple;
  model DiffHL "diffusion following Hill-Langmuir kinetics"
    extends Diffusion;
    parameter Real p(unit="1/s") "rate coefficient (inverse of time constant)";
    parameter SI.Concentration ka "concentration producing half occupation";
    parameter Real n(unit="1") "Hill coefficient";
  equation
    j = (src.c - dst.c) * p * hillLangmuir(dst.c, ka, n);
  end DiffHL;
  model DiffMM "diffusion following Michaelis-Menten kinetics"
    extends Diffusion;
    parameter Real p(unit="mol/(m3.s)") "diffusion coefficient";
    parameter SI.Concentration k "Michaelis constant";
  equation
    j = p * michaelisMenten(src.c, k);
  end DiffMM;
  partial model BufferBase "base model for buffer substances"
    IonConcentration c;
    parameter SI.Concentration c_tot "total concentration of buffer";
    parameter Real f_start(unit="1") "initial value for f";
    parameter Real k "association constant";
    parameter Real kb "dissociation constant";
    Real f(start=f_start, fixed=true) "fractional occupancy of buffer by Ca2+";
  equation
    c.rate = c_tot * der(f);
  end BufferBase;
  model Buffer "buffer with a single target"
    extends BufferBase;
  equation
    der(f) = k * c.c * (1 - f) - kb * f;
  end Buffer;
  model Buffer2 "buffer that can bind to two different molecules"
    extends BufferBase;
    Real f_other(unit="1") "fractional occupancy of buffer by other molecule";
  equation
    der(f) = k * c.c * (1 - f - f_other) - kb * f;
  end Buffer2;
  model CaHandlingK "handling of Ca concentation by Kurata 2002"
    outer parameter SI.Volume v_sub, v_cyto, v_nsr, v_jsr;
    ConstantConcentration mg(c_const=2.5) "Mg2+ concentration";
    Compartment sub(vol=v_sub) "Ca2+ in subspace";
    Compartment cyto(vol=v_cyto) "Ca2+ in cytosol";
    Compartment jsr(vol=v_jsr) "Ca2+ in JSR";
    Compartment nsr(vol=v_nsr) "Ca2+ in NSR";
    DiffSimple sub_cyto(flip=true, v_src=sub.vol, v_dst=cyto.vol, tau=0.04e-3)
      "diffusion from subspace to cytosol"; // tau = tau_diff,Ca
    DiffMM cyto_nsr(v_src=cyto.vol, v_dst=nsr.vol,p=0.005e3,k=0.0006)
      "diffusion from cytosol to NSR (i.e. Ca2+ uptake by SR)"; // p = P_up, k = K_up
    DiffSimple nsr_jsr(v_src=nsr.vol, v_dst=jsr.vol, tau=60e-3)
      "diffusion from NSR to JSR"; // tau = tau_tr
    DiffHL jsr_sub(flip=true, v_src=jsr.vol, v_dst=sub.vol, p=5e3, ka=0.0012, n=2)
      "diffusion from JSR to subspace (i.e. Ca2+ release by SR)"; // p = P_rel, k = K_rel
    Buffer tc(c_tot=0.031, k=88.8e3, kb=0.446e3) "troponin-Ca";
    Buffer2 tmc(c_tot=0.062, k=227.7e3, kb=0.00751e3) "troponin-Mg binding to Ca2+";
    Buffer2 tmm(c_tot=0, k=2.277e3, kb=0.751e3) "troponin-Mg binding to Mg2+"; // c_tot not relevant since {Mg2+]_i is constant
    model BufferCM = Buffer(c_tot=0.045, k=227.7e3, kb=0.542e3) "base model for calmodulin";
    BufferCM cm_cyto "calmodulin in cytosol";
    BufferCM cm_sub "calmodulin in subspace";
    Buffer cq(c_tot=10, k=0.534e3, kb=0.445e3) "calsequestrin";
  equation
    tmc.f_other = tmm.f;
    tmm.f_other = tmc.f;
    connect(sub.c, sub_cyto.src);
    connect(cyto.c, sub_cyto.dst);
    connect(cyto.c, cyto_nsr.src);
    connect(nsr.c, cyto_nsr.dst);
    connect(nsr.c, nsr_jsr.src);
    connect(jsr.c, nsr_jsr.dst);
    connect(jsr.c, jsr_sub.src);
    connect(sub.c, jsr_sub.dst);
    connect(tc.c, cyto.c);
    connect(tmc.c, cyto.c);
    connect(tmm.c, mg.c);
    connect(cm_cyto.c, cyto.c);
    connect(cm_sub.c, sub.c);
    connect(cq.c, jsr.c);
  end CaHandlingK;
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
    Buffer cm_sl(c_tot=0.031/1.2, k=0.115e3, kb=1e3) "calmodulin in sarcolemma";
  equation
    connect(cm_sl.c, sub.c);
  end CaHandling;

  model IonFlux
    IonConcentration ion "ion whose concentration changes";
    outer SI.Current i_ion "current responsible for moving ions";
    parameter SI.Volume vol "volume of compartment";
    parameter Real n "soichiometric ratio of ion transport";
  equation
    ion.rate = n * (i / vol * Modelica.Constants.F);
  end IonFlux;

  model NaFlux
    IonConcentration na;
    parameter SI.Volume vol;
    parameter Real n_na = 1;
    IonFlux flux_na(vol=vol, n=n_na);
  equation
    connect(na, flux_na.ion);
  end NaFlux;

  model KFlux
    IonConcentration k;
    parameter SI.Volume vol;
    parameter Real n_k;
    IonFlux flux_k(vol=vol, n=n_k);
  equation
    connect(k, flux_k.ion);
  end KFlux;

  model CaFlux
    IonConcentration ca;
    parameter SI.Volume vol;
    parameter Real n_ca;
    IonFlux flux_ca(vol=vol, n=n_ca);
  equation
    connect(ca, flux_ca.ion);
  end CaFlux;
end IonConcentrations;
