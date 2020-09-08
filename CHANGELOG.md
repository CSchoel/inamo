# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

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


## [1.0.0]

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
