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

function testmodel(omc, name, stoptime, stepsize; tolerance=1e-6)
    intervals = trunc(Int, stoptime / stepsize)
    r = OMJulia.sendExpression(omc, "loadModel($name)")
    @test r
    es = OMJulia.sendExpression(omc, "getErrorString()")
    @test es == ""
    r = OMJulia.sendExpression(omc, "simulate($name, stopTime=$stoptime, numberOfIntervals=$intervals, tolerance=$tolerance, outputFormat=\"csv\")")
    @test !occursin("| warning |", r["messages"])
    @test !startswith(r["messages"], "Simulation execution failed")
    es = OMJulia.sendExpression(omc, "getErrorString()")
    @test es == ""
    println(es)
end

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
            testmodel(omc, "InaMo.Examples.SodiumChannelSteady", 70, 1e-2)
        end
        @testset "SodiumChannelIV" begin
            testmodel(omc, "InaMo.Examples.SodiumChannelIV", 74, 1e-2; tolerance=1e-12) # 1e-5
        end
        @testset "InwardRectifierLin" begin
            testmodel(omc, "InaMo.Examples.InwardRectifierLin", 150, 1; tolerance=1e-12)
        end
        @testset "GHKFlux" begin
            testmodel(omc, "InaMo.Examples.GHKFlux", 100, 1e-1)
        end
        @testset "LTypeCalciumSteady" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumSteady", 140, 1)
        end
        @testset "LTypeCalciumIV" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIV", 155, 1e-2; tolerance=1e-12)
        end
        @testset "LTypeCalciumIVN" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIVN", 155, 1e-2; tolerance=1e-12)
        end
        @testset "LTypeCalciumStep" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumStep", 2, 1e-4)
        end
        @testset "TransientOutwardSteady" begin
            testmodel(omc, "InaMo.Examples.TransientOutwardSteady", 200, 1)
        end
        @testset "TransientOutwardIV" begin
            testmodel(omc, "InaMo.Examples.TransientOutwardIV", 520, 1e-2; tolerance=1e-12)
        end
        @testset "RapidDelayedRectifierSteady" begin
            testmodel(omc, "InaMo.Examples.RapidDelayedRectifierSteady", 200, 1)
        end
        @testset "RapidDelayedRectifierIV" begin
            testmodel(omc, "InaMo.Examples.RapidDelayedRectifierIV", 115, 1e-2; tolerance=1e-12)
        end
        @testset "HyperpolarizationActivatedSteady" begin
            testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedSteady", 80, 1)
        end
        @testset "HyperpolarizationActivatedIV" begin
            testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedIV", 340, 1e-1)
        end
        @testset "SustainedInwardSteady" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardSteady", 140, 1)
        end
        @testset "SustainedInwardIV" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardIV", 465, 1e-2; tolerance=1e-12)
        end
        @testset "SustainedInwardIVKurata" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardIVKurata", 465, 1e-2; tolerance=1e-12)
        end
    end
finally
    println("Closing OMC session")
    sleep(1)
    OMJulia.sendExpression(omc, "quit()", parsed=false)
    println("Done")
end
