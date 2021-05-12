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
%libs=Modelica@3.2.3
InaMo.ExperimentalMethods
```

## Base classes

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.ExperimentalMethods.Interfaces.TestPulses
```

## Voltage clamp methods

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp
InaMo.ExperimentalMethods.VoltageClamp.VCTestPulses
InaMo.ExperimentalMethods.VoltageClamp.VCTestPulsesPeak
```

## Current clamp methods

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.ExperimentalMethods.CurrentClamp.CurrentClamp
InaMo.ExperimentalMethods.CurrentClamp.CCTestPulses
```
