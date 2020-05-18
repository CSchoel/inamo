using OMJulia
using Base.Filesystem
using Test
include("MoST/src/julia/MoST.jl")
using .MoST

moroot = dirname(@__DIR__)
outdir = joinpath(moroot, "out")
if !ispath(outdir)
    mkdir(outdir)
end
refdir = joinpath(moroot, "regRefData")

omc = MoST.setupOMCSession(outdir, moroot)
rrtol = 1e-6
try
    @testset "Simulate examples" begin
        @testset "SodiumChannelSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumChannelSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumChannelIV" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumChannelIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "InwardRectifierLin" begin
            MoST.testmodel(omc, "InaMo.Examples.InwardRectifierLin"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "GHKFlux" begin
            MoST.testmodel(omc, "InaMo.Examples.GHKFlux"; override=Dict(
                "stopTime"=>100, "numberOfIntervals"=>1000
            ), refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumIV" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumIVN" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumIVN"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumStep" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumStep"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "TransientOutwardSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.TransientOutwardSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "TransientOutwardIV" begin
            MoST.testmodel(omc, "InaMo.Examples.TransientOutwardIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "RapidDelayedRectifierSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.RapidDelayedRectifierSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "RapidDelayedRectifierIV" begin
            MoST.testmodel(omc, "InaMo.Examples.RapidDelayedRectifierIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "HyperpolarizationActivatedSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "HyperpolarizationActivatedIV" begin
            MoST.testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardIV" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardIVKurata" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardIVKurata"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumPotassiumPumpLin" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumPotassiumPumpLin"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerRampInada" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerRampInada"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerLinMatsuoka" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinMatsuoka"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerLinKurata" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinKurata"; refdir=refdir, regRelTol=rrtol)
        end
    end
finally
    MoST.closeOMCSession(omc)
end
