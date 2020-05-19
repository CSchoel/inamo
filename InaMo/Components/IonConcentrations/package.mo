within InaMo.Components;
package IonConcentrations
  import InaMo.Components.Functions.*;
  import InaMo.Components.Connectors.*;
  model ConstantConcentration
    IonConcentration c;
    parameter SI.Concentration c_const = 1;
  equation
    c.c = c_const;
  end ConstantConcentration;
  model Compartment
    IonConcentration c;
    parameter SI.Concentration c_start = 1;
  initial equation
    c.c = c_start;
  equation
    der(c.c) = c.rate;
  end Compartment;
  partial model Diffusion
    IonConcentration pos;
    IonConcentration neg;
    Real j;
    parameter Real v_pos = 1;
    parameter Real v_neg = 1;
    parameter Boolean flip = false;
  equation
    if flip then
      pos.rate = -j * v_neg / v_pos;
      neg.rate = j;
    else
      pos.rate = -j;
      neg.rate = j * v_pos / v_neg;
    end if;
  end Diffusion;
  model DiffSimple
    extends Diffusion;
    parameter SI.Duration tau;
  equation
    j = (pos.c - neg.c) / tau;
  end DiffSimple;
  model DiffHL
    extends Diffusion;
    parameter Real p;
    parameter Real ka;
    parameter Real n;
  equation
    j = (pos.c - neg.c) * p * hillLangmuir(neg.c, ka, n);
  end DiffHL;
  model DiffMM
    extends Diffusion;
    parameter Real p;
    parameter Real k;
  equation
    j = p * michaelisMenten(neg.c, k);
  end DiffMM;
  partial model BufferBase
    IonConcentration c;
    parameter SI.Concentration c_tot;
    parameter Real f_start;
    parameter Real k;
    parameter Real kb;
    Real f(start=f_start, fixed=true);
  equation
    c.rate = c_tot * f;
  end BufferBase;
  model Buffer
    extends BufferBase;
  equation
    der(f) = k * c.c * (1 - f) - kb * f;
  end Buffer;
  model Buffer2 // buffer that can bind to two proteins
    extends BufferBase;
    Real f_other;
  equation
    der(f) = k * c.c * (1 - f - f_other) - kb * f;
  end Buffer2;
  model CaHandlingK "handling of Ca concentation by Kurata 2002"
    outer parameter SI.Volume v_sub, v_cyto, v_nsr, v_jsr;
    ConstantConcentration mg(c_const=2.5);
    Compartment sub;
    Compartment cyto;
    Compartment jsr;
    Compartment nsr;
    DiffSimple sub_cyto(flip=true, v_pos=v_sub, v_neg=v_cyto, tau=0.04e-3); // tau = tau_diff,Ca
    DiffMM cyto_nsr(v_pos=v_cyto, v_neg=v_nsr,p=0.005e-3,k=0.0006); // p = P_up, k = K_up
    DiffSimple nsr_jsr(v_pos=v_nsr, v_neg=v_jsr, tau=60e-3); // tau = tau_tr
    DiffHL jsr_sub(flip=true, v_pos=v_jsr, v_neg=v_sub, p=5e-3, ka=0.0012, n=2); // p = P_rel, k = K_rel
    Buffer tc(c_tot=0.031, k=88.8e-3, kb=0.446e-3);
    Buffer2 tmc(c_tot=0.062, k=227.7e-3, kb=0.00751e-3);
    Buffer2 tmm(c_tot=0, k=2.277e-3, kb=0.751e-3); // c_tot not relevant since {Mg2+]_i is constant
    model BufferCM = Buffer(c_tot=0.045, k=227.7e-3, kb=0.542e-3);
    BufferCM cm_cyto;
    BufferCM cm_sub;
    Buffer cq(c_tot=10, k=0.534e-3, kb=0.445e-3);
  equation
    connect(tmc.f_other, tmm.c.c);
    connect(tmm.f_other, tmc.c.c);
    connect(sub.c, sub_cyto.pos);
    connect(cyto.c, sub_cyto.neg);
    connect(cyto.c, cyto_nsr.neg);
    connect(nsr.c, cyto_nsr.pos);
    connect(nsr.c, nsr_jsr.neg);
    connect(jsr.c, nsr_jsr.pos);
    connect(jsr.c, jsr_sub.pos);
    connect(sub.c, jsr_sub.neg);
    connect(tc.c, cyto.c);
    connect(tmc.c, cyto.c);
    connect(tmm.c, mg.c);
    connect(cm_cyto.c, cyto.c);
    connect(cm_sub.c, sub.c);
    connect(cq.c, jsr.c);
  end CaHandlingK;
  model CaHandling "extension of Ca handling by Inaada 2009"
    extends CaHandlingK;
    // FIXME: no value is given for cm_sl.c_tot in Inada 2009 (SL_tot)
    Buffer cm_sl(c_tot=cm_cyto.c_tot, k=115e-3, kb=1e-3);
  equation
    connect(cm_sl.c, sub.c);
  end CaHandling;
end IonConcentrations;
