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

function testmodel(omc, name, stoptime, stepsize)
    intervals = trunc(Int, stoptime / stepsize)
    r = OMJulia.sendExpression(omc, "loadModel($name)")
    @test r
    es = OMJulia.sendExpression(omc, "getErrorString()")
    @test es == ""
    r = OMJulia.sendExpression(omc, "simulate($name, stopTime=$stoptime, numberOfIntervals=$intervals, outputFormat=\"csv\")")
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
            testmodel(omc, "InaMo.Examples.SodiumChannelSteady", 80, 1e-2)
        end
        @testset "SodiumChannelIV" begin
            testmodel(omc, "InaMo.Examples.SodiumChannelIV", 80, 1e-2) # 1e-5
        end
        @testset "InwardRectifierLin" begin
            testmodel(omc, "InaMo.Examples.InwardRectifierLin", 200, 1e-1)
        end
        @testset "GHKFlux" begin
            testmodel(omc, "InaMo.Examples.GHKFlux", 100, 1e-1)
        end
        @testset "LTypeCalcium" begin
            testmodel(omc, "InaMo.Examples.LTypeCalcium", 140, 1)
        end
        @testset "LTypeCalciumIV" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIV", 800, 1e-2)
        end
        @testset "LTypeCalciumIVN" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIVN", 800, 1e-2)
        end
        @testset "LTypeCalciumStep" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumStep", 2, 1e-4)
        end
    end
finally
    println("Closing OMC session")
    sleep(1)
    OMJulia.sendExpression(omc, "quit()", parsed=false)
    println("Done")
end
