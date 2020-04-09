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

function testmodel(omc, name; override=Dict())
    r = OMJulia.sendExpression(omc, "loadModel($name)")
    @test r
    es = OMJulia.sendExpression(omc, "getErrorString()")
    @test es == ""
    values = OMJulia.sendExpression(omc, "getSimulationOptions($name)")
    settings = Dict(
        "startTime"=>values[1], "stopTime"=>values[2],
        "tolerance"=>values[3], "numberOfIntervals"=>values[4],
        "outputFormat"=>"\"csv\""
    )
    for x in keys(settings)
        if x in keys(override)
            settings[x] = override[x]
        end
    end
    setstring = join(("$k=$v" for (k,v) in settings), ", ")
    r = OMJulia.sendExpression(omc, "simulate($name, $setstring)")
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
            testmodel(omc, "InaMo.Examples.SodiumChannelSteady")
        end
        @testset "SodiumChannelIV" begin
            testmodel(omc, "InaMo.Examples.SodiumChannelIV")
        end
        @testset "InwardRectifierLin" begin
            testmodel(omc, "InaMo.Examples.InwardRectifierLin")
        end
        @testset "GHKFlux" begin
            testmodel(omc, "InaMo.Examples.GHKFlux"; override=Dict(
                "stopTime"=>100, "numberOfIntervals"=>1000
            ))
        end
        @testset "LTypeCalciumSteady" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumSteady")
        end
        @testset "LTypeCalciumIV" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIV")
        end
        @testset "LTypeCalciumIVN" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIVN")
        end
        @testset "LTypeCalciumStep" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumStep")
        end
        @testset "TransientOutwardSteady" begin
            testmodel(omc, "InaMo.Examples.TransientOutwardSteady")
        end
        @testset "TransientOutwardIV" begin
            testmodel(omc, "InaMo.Examples.TransientOutwardIV")
        end
        @testset "RapidDelayedRectifierSteady" begin
            testmodel(omc, "InaMo.Examples.RapidDelayedRectifierSteady")
        end
        @testset "RapidDelayedRectifierIV" begin
            testmodel(omc, "InaMo.Examples.RapidDelayedRectifierIV")
        end
        @testset "HyperpolarizationActivatedSteady" begin
            testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedSteady")
        end
        @testset "HyperpolarizationActivatedIV" begin
            testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedIV")
        end
        @testset "SustainedInwardSteady" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardSteady")
        end
        @testset "SustainedInwardIV" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardIV")
        end
        @testset "SustainedInwardIVKurata" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardIVKurata")
        end
        @testset "SodiumPotassiumPumpLin" begin
            testmodel(omc, "InaMo.Examples.SodiumPotassiumPumpLin")
        end
        @testset "SodiumCalciumExchangerRampInada" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerRampInada")
        end
        # @testset "SodiumCalciumExchangerLin" begin
        #     testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLin")
        # end
        @testset "SodiumCalciumExchangerLinMatsuoka" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinMatsuoka")
        end
        @testset "SodiumCalciumExchangerLinInada" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinInada")
        end
        @testset "SodiumCalciumExchangerLinKurata" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinKurata")
        end
    end
finally
    println("Closing OMC session")
    sleep(1)
    OMJulia.sendExpression(omc, "quit()", parsed=false)
    println("Done")
end
