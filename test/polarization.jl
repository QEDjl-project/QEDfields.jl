
using QEDbase
using QEDfields
using Random
using IntervalSets

RNG = MersenneTwister(137)
ATOL = eps()
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG,4))
POL_SET = [PolX(), PolY()]

@testset "polarization vectors" begin
    @testset "$mom" for mom in [SFourMomentum(1,0,0,1),RND_MOM]
        @testset "single $pol" for pol in POL_SET
            pol_vec = polarization_vector(pol,mom)
            @test isapprox(pol_vec*pol_vec, -one(eltype(pol_vec)), atol = ATOL, rtol = RTOL)
            @test isapprox(pol_vec*mom, zero(eltype(mom)), atol = ATOL, rtol = RTOL)
        end

        @testset "both polarizations" begin
            pol_vec1 = polarization_vector(PolX(),mom)
            pol_vec2 = polarization_vector(PolY(),mom)

            @test isapprox(pol_vec1*pol_vec2, zero(eltype(pol_vec1)), atol = ATOL, rtol = RTOL)
        end
    end
end
