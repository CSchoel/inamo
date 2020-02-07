using OMJulia
using Base.Filesystem
using Test

moroot = dirname(@__DIR__)
outdir = "out"
cd(moroot)
if !ispath(outdir)
    mkdir(outdir)
end
cd(outdir)

omc = OMJulia.OMCSession()
try
    mopath = OMJulia.sendExpression(omc, "getModelicaPath()")
    mopath = "$mopath:$(escape_string(moroot))"
    println("Setting MODELICAPATH to ", mopath)
    OMJulia.sendExpression(omc, "setModelicaPath(\"$mopath\")")
    # load Modelica standard library
    OMJulia.sendExpression(omc, "loadModel(Modelica)")
    @testset "Simulate examples" begin
        @testset "SodiumChannelSteady" begin
            r = OMJulia.sendExpression(omc, "loadModel(InaMo.Examples.SodiumChannelSteady)")
            @test r
            es = OMJulia.sendExpression(omc, "getErrorString()")
            @test es == ""
            r = OMJulia.sendExpression(omc, "simulate(InaMo.Examples.SodiumChannelSteady, stopTime=80, numberOfIntervals=8000, outputFormat=\"csv\")")
            @test !occursin("| warning |", r["messages"])
            es = OMJulia.sendExpression(omc, "getErrorString()")
            @test es == ""
        end
        @testset "SodiumChannelIV" begin
            r = OMJulia.sendExpression(omc, "loadModel(InaMo.Examples.SodiumChannelIV)")
            @test r
            es = OMJulia.sendExpression(omc, "getErrorString()")
            @test es == ""
            r = OMJulia.sendExpression(omc, "simulate(InaMo.Examples.SodiumChannelIV, stopTime=80, numberOfIntervals=800000, outputFormat=\"csv\")")
            @test !occursin("| warning |", r["messages"])
            es = OMJulia.sendExpression(omc, "getErrorString()")
            @test es == ""
        end
    end
finally
    println("Closing OMC session")
    sleep(1)
    OMJulia.sendExpression(omc, "quit()", parsed=false)
    println("Done")
end
