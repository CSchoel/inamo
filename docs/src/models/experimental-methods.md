# Experimental methods

!!! note

    This documentation is work in progress.
    Currently, the extension of Documenter.jl in my package [MoST.jl](https://github.com/THM-MoTE/ModelicaScriptingTools.jl) is still experimental.
    As the package evolves further, this documentation will increase in readability.

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.ExperimentalMethods
```

## Base classes

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.ExperimentalMethods.Interfaces.TestPulses
```

## Voltage clamp methods

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp
InaMo.ExperimentalMethods.VoltageClamp.VCTestPulses
InaMo.ExperimentalMethods.VoltageClamp.VCTestPulsesPeak
```

## Current clamp methods

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.ExperimentalMethods.CurrentClamp.CurrentClamp
InaMo.ExperimentalMethods.CurrentClamp.CCTestPulses
```
