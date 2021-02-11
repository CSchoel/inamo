# InaMo

InaMo is an understandable modular reimplementation of the one-dimensional model of the rabbit atrioventricular node by Inada et al. [\[1\]](#ref1) in the language Modelica.
It aims to facilitate reproduction of both the methods and results of Inada et al. and of our own article [\[2\]](#ref2).

The InaMo project also contains Julia scripts for running simulations and testing models and Python scripts for plotting.

## The Inada model

The Inada model was the first detailed electrophysiological model of the AV node. It consists of three types of cells (AN: atrionodal, N: nodal, NH: nodal-his), which are connected to a one-dimensional structure along with sinoatrial and atrial cells by other researchers.
This implementation currently only contains the individual cell models and not the whole one-dimensional model of the AV node.

The individual cells consist of the following components:

* ion channels
    * background channel (``I_b``)
    * L-type calcium channel (``I_{Ca,L}``)
    * rapid delayed rectifier channel (``I_{K,r}``)
    * inward rectifier channel (``I_{K,1}``)
    * sodium channel (``I_{Na}``)
    * transient outward channel (``I_{to}``)
    * hyperpolarization-activated channel (``I_f``)
    * sustained outward channel (``I_{st}``)
    * RyanodineReceptor (only used for Ca2+ concentration)
* ion pumps
    * sodium calcium exchanger (``I_{NaCa}``)
    * sodium potassium pump (``I_p``)
    * SERCA pump (only used for Ca2+ concentration)
* compartments containing variable Ca 2+ concentrations
    * cytoplasm (``[Ca^{2+}]_i``)
    * junctional sarcoplasmic reticulum (JSR) (``[Ca^{2+}]_{jsr}``)
    * network sarcoplasmic reticulum (NSR) (``[Ca^{2+}]_{nsr}``)
    * “fuzzy” subspace (``[Ca^{2+}]_{sub}``), which is the “functionally restricted intracellular space accessible to the Na+/Ca2+ exchanger as well as to the L-type Ca2+ channel and the Ca2+-gated Ca2+ channel in the SR”
* concentrations assumed to be constant
    * extracellular calcium concentration (``[Ca^{2+}]_{o}``)
    * intra- and extracellular sodium concentrations (``[Na^{+}]_{i}``, ``[Na^{+}]_{o}``)
    * intra- and extracellular potassium concentrations (``[K^{+}]_{i}``, ``[K^{+}]_{o}``)

## Modelica Implementation

!!! note

    This documentation is work in progress.
    Currently, the extension of Documenter.jl in my package [MoST.jl](https://github.com/THM-MoTE/ModelicaScriptingTools.jl) is still experimental.
    As the package evolves further, this documentation will increase in readability.

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
InaMo.Examples.FullCell.AllCells
```

## Unit tests for Modelica models

## Continuous integration

## References

<a name="ref1">[1]</a> S. Inada, J. C. Hancox, H. Zhang, and M. R. Boyett, “One-dimensional mathematical model of the atrioventricular node including atrio-nodal, nodal, and nodal-his cells,” Biophys. J., vol. 97, no. 8, pp. 2117–2127, 2009, doi: [10.1016/j.bpj.2009.06.056](https://doi.org/10.1016/j.bpj.2009.06.056).

<a name="ref2">[2]</a> C. Schölzel, V. Blesius, G. Ernst, A. Goesmann, and A. Dominik, “Countering reproducibility issues in mathematical models with software engineering techniques: A case study using a one-dimensional mathematical model of the atrioventricular node,” unpublished, 2021.
