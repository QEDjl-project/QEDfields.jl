using QEDfields
using Test
using Pkg: Pkg

function isinstalled(pk::AbstractString)
    return pk in [v.name for v in values(Pkg.dependencies())]
end

@testset "QEDfields.jl" begin
    # Write your tests here.

    @testset "Integration: QEDbase" begin
        @test isinstalled("QEDbase")
        @test length(dummy_QEDbase(rand(4))) == 4
    end
end

@testset "background field interface" begin
    include("interfaces/background_field_interface.jl")
end
