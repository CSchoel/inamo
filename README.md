# InaMo

![Build Status](https://github.com/CSchoel/inamo/workflows/Run%20tests%20and%20deploy%20docs/badge.svg)
[![Documentation stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://cschoel.github.io/inamo/stable/)

This project contains a reusable, reproducible, understandable, and extensible reimplementation of the one-dimensional model of the rabbit atrioventricular node by Inada et al. [\[1\]](#ref1).
InaMo is written in Modelica and follows our guidelines for writing models in MoDROGH-languages [\[2\]](#ref2).

## Features

* Composed of small modules with minimal interfaces that are reused throughout the code to avoid code duplication
* Declarative code that focuses on conveying biological meaning instead of technical implementation details
* Reference simulation data published in separate repository [inamo-ref](https://github.com/CSchoel/inamo-ref)
* Variables and parameters with speaking names, SI units, and documentation strings
* Explanations and literature references for all model components
* A reference and/or rationale for every parameter value
* Extensive unit tests based on reference plots from literature
* Graphical representation of components and whole model
* HTML documentation that is generated from the model code using [MoST.jl](https://github.com/THM-MoTE/ModelicaScriptingTools.jl) (WIP)
* A [changelog](CHANGELOG.md) that captures all significant changes to this project
* Continuous integration pipelines that guarantees that
  * the full environment required for simulation can be obtained from `.travis.yml`
  * models can be simulated without errors
  * simulations produce identical results to reference
  * simulations work on a machine that is physically separated from development environment
  * units are consistent across all models
  * documentation remains up to date (WIP)

## Quick start for replication

To simulate the models in this repository on your own machine, you can use the following steps:

* Download and install the following software for your operating system
  * [OpenModelica](https://www.openmodelica.org/)
  * [Julia](https://julialang.org/) (for unit tests)
  * The Python distribution [Anaconda](https://www.anaconda.com/products/individual) (for plots)
    * alternatively install the packages listed in `requirements.txt` for your existing Python version
* Clone this repository with Git or download a [ZIP file of the current master branch](https://github.com/CSchoel/hh-modelica/archive/master.zip) and extract it with an archive manager of your choice.
* Run the following commands in a command prompt from the main folder of this project
  * `julia -e 'using Pkg; Pkg.add("ModelicaScriptingTools")'` (installs MoST.jl)
  * `julia scripts/unittests.jl` (runs unittests)
  * `python scripts/plot_validation.py` (produces plots)

Alternatively, you can also simulate the models without Python and Julia by using the OpenModelica Connection Editor (OMEdit):

* Download and install [OpenModelica](https://www.openmodelica.org/) for your operating system
* Start OMEdit and open the folder `InaMo` with "File" → "Load Library".
* Open the model you want to simulate, e.g. `InaMo.Examples.FullCell.AllCells` (select from "Libraries Browser" on the left hand side with a double click).
* Simulate the model with "Simulation" → "Simulate".
* In the "Variables Browser" on the right hand side select the variable `an.cell.v`, `n.cell.v`, and `nh.cell.v`.

## Documentation

A detailed [documentation of InaMo](https://cschoel.github.com/inamo/dev) can be found on GitHub pages. (WIP)

## References

<a name="ref1">[1]</a> S. Inada, J. C. Hancox, H. Zhang, and M. R. Boyett, “One-dimensional mathematical model of the atrioventricular node including atrio-nodal, nodal, and nodal-his cells,” Biophys. J., vol. 97, no. 8, pp. 2117–2127, 2009, doi: [10.1016/j.bpj.2009.06.056](https://doi.org/10.1016/j.bpj.2009.06.056).

<a name="ref2">[2]</a> C. Schölzel, V. Blesius, G. Ernst, and A. Dominik, “The impact of mathematical modeling languages on model quality in systems biology: A software engineering perspective,” bioRxiv, preprint 10.1101/2019.12.16.875260v3, 2020. doi: [10.1101/2019.12.16.875260](https:://doi.org/10.1101/2019.12.16.875260).

## Publication

This project will be published in a peer reviewed journal.
I will add the reference to the paper when it is finished.
