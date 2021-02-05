# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

[nothing]

### Changed

[nothing]

### Fixed

[nothing]

## [1.4.0] - 2021-02-05

### Added

* more descriptive labels and titles for naca_matsuoka1992_19
* hint in documentation that absolute values for naca_matsuoka1992_19 can be found in Figures 15--17
* release workflow now pulls release notes from changelog
* documentation strings for *all* models, variables, and parameters
* HTML documentation for all aspects of code structure that are not immediately apparent and all differences to articles
* Icons for all packages and components (except atrial cell model)
* `ReversibleAssociation` model used to construct `Buffer` and `Buffer2` in a modular way

### Changed

* reduced Figure size for to_inada2009_S2E
* `TestPulses` now includes `d_pulse` in the cycle duration for a more intuitive interpretation
* test for `AllCellsC` now also uses `regRelTol=1e-3` because of error accumulation in N cell
* `TestPulsesPeak` can now detect peaks at start or end of observed time period
* renamed fitting functions
  * `generalizedLogisticFit` -> `genLogistic`
  * `goldmanFit` -> `goldman`
  * `negSquaredExpFit` -> `gaussianAmp` (duh!)
  * `scaledExpFit` -> `expFit`
* restructured entire package hierarchy (for a list of renamings see [pull request #7](https://github.com/CSchoel/inamo/pull/7/files))
* the model `Buffer2` now encapsulates the behavior of the two interconnected instances required in the previous implementation
* instead of `CalciumSite` and `MagnesiumSite`, there is now only one connector named `SubstanceSite`

### Fixed

* make all icons and diagrams work with OpenModelica 1.16.0
  * use fully qualified names instead of imports for all visible components
  * avoid `redeclare` of visible components
* models with constant Ca2+ used a concentration of 10e-4 mM, but this should be 1e-4 mM
* documentation of `AllCells` talked about `d_pulse`, but `d_hold` was meant
* plots for I_K,r were accidentally prefixed `kir_` instead of `kr_`
* figure st_inada2009_S5B used raw current instead of current density
* Lindblad1996 was called Lindblad1997 in some instances

### Removed

* old Python version of testing suite: `scripts/unittests.py`
* now unused connectors `SodiumSite`, `PotassiumSite`, `MagnesiumSite`, `CalciumSite`, `BufferOccupancyIn`, and `BufferOccupancyOut`

## [1.3.0] - 2021-01-15

### Added

* Github Actions workflow for unit tests
* Github Actions workflow for building release archive
* generic component `ECAdapter`, that translates between electrical current and chemical flow rate
* `ElectricalIonTransport` is the new base class for `Transmembrane*Flow` (via `EITransportConst`)
* `InactiveChemicalTransport` is the new base class for `Diffusion` and for `RyanodineReceptor`
* smoke test for atrial cell model (only tests if model compiles)
* new icons for `SERCAPump` and `RyanodineReceptor`
* icons `InsideBottomOutsideTop` and `InsideTopOutsideBottom` for different position of background rectangle for ion channels and pumps

### Changed

* revises the entire structure and documentation of the calcium concentration handling
  * `cyto_nsr` is no diffusion reaction, but the SERCA pump ⇒ `DiffMM` is renamed to `SERCAPump`
  * `jsr_sub` is no diffusion reaction, but an ryanodine receptor ⇒ `DiffHL` is renamed to  `RyanodineReceptor`
  * consequently, the base model is not `Diffusion`, but `SubstanceTransport`
  * to avoid naming confusions, the `*Flux` models are renamed to `Transmembrane*Flow`
  * Experiments are also renamed accordingly (`CaDiffusionSimple` → `CaDiffusion`, `CaDiffusionMM` → `CaSERCA`, `CaDiffusionHL` → `CaRyanodineReceptor`)
  * base classes for atrial cell model are adjusted as far as possible
  * in order to reuse icons, `SERCAPump` and `RyanodineReceptor` now also have their "inside" connector at the bottom and their "outside" connector at the top
  * icon for `Diffusion` is also rotated to a vertical orientation
* `IonChannel` icon is now named `LipidBilayerWithGap`

### Fixed

* atrial cell model can be compiled again

### Removed

* Travis CI script is disabled (due to policy changes)

## [1.2.0] - 2020-11-26

### Added

- unit tests for buffer and diffusion components
- generate release from Travis CI script

### Changed

- uses substance amounts instead of concentrations in connectors, because mass is conserved while concentrations are not
- plots updated for publication (added grids, reduced size, removed debug info)

### Fixed

- simulation tolerances are set back to 1e-6 instead of 1e-12
- zero-crossing equations in VCTestPulsesPeak and InwardRectifierLin are multiplied with constant to stay within default tolerance
- all connector variables and some additional current variables now have a meaningful nominal value

## [1.1.0] - 2020-11-11

### Added

* (untested) implementation of atrial cell model by Lindblad et al. (1996)
* flux models for mixin-style definition of ion fluxes
* README.md file
* this changelog
* MIT license
* icons for all components and diagram views for (almost) all examples

### Changed

* simplifies I_Ca and I_NaCa using CaFlux
* simplifies diffusion models by removing flip variable
  * due to observation that volume in numerator is always minimum of both volumes
* reduces interface of base Diffusion model to only `src` and `dst`
* allows variable `na_in` in SodiumChannel (needed for atrial cell model)
* renames `*_out` to `*_ex` for concentrations
* uses MoST.jl as package instead of as submodule
  * unittests now require `ModelicaScriptingTools` instead of `OMJulia`
* uses new vendor-specific annotation `__MoST_experiment(variableFilter=..)` instead of old `__ChrisS_testing(testedVariableFilter=...)`
* simplifies Travis CI script due to new MoST.jl pipeline
* adds documentation using Documenter.jl and MoST.jl
* renames package `IonChannels` to `IonCurrents` to better capture both channels and pumps
* renames package `Connectors` to `Interfaces` and moves it to the top of the hierarchy
* moves models in `IonConcentrations` to separate files

### Fixed

* I_NaK now uses `i_max` value given by Inada 2009 by default (instead of value by Zhang 2000)
* SodiumPotassiumPumpLin example uses `k_m_Na` value given by Demir 1994 (5.46 instead of 5.64)

### Removed

* old temperature connectors


## [1.0.0] - 2020-06-24

### Added

* full implementation of AN, N and NH cell model by Inada et al. (2009)
* Julia test suite with regression tests
* Python test suite (outdated)
* Python script for generating plots
* Travis CI script that runs julia test suite automatically

### Changed

[nothing]

### Fixed

[nothing]
