###################
# check if upstream packages provide the assumed functionality
###################

using Pkg: Pkg

# QEDbase.jl

using QEDbase: QEDbase

@testset "Integration: QEDbase" begin
    QEDbase_exports = names(QEDbase)

    @testset "General" begin
        @test :SFourMomentum in QEDbase_exports
        @test :base_state in QEDbase_exports
    end

    @testset "Polarizations" begin
        @test :PolarizationX in QEDbase_exports
        @test :PolX in QEDbase_exports
        @test :PolarizationY in QEDbase_exports
        @test :PolY in QEDbase_exports
        @test :AllPolarization in QEDbase_exports
        @test :AllPol in QEDbase_exports
    end
end
