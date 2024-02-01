using Random
using IntervalSets
using QEDfields
using QEDbase

RNG = MersenneTwister(123456789)
ATOL = eps()
RTOL = sqrt(eps())

DPHIS = [rand(RNG), rand(RNG)*10, rand(RNG)*100,rand(RNG)*1000,rand(RNG),10000]

@testset "pulse interface" begin
    @test hasmethod(reference_momentum,Tuple{CosSquarePulse})
    @test hasmethod(domain,Tuple{CosSquarePulse})
    @test hasmethod(phase_duration,Tuple{CosSquarePulse})
    @test hasmethod(QEDfields._envelope,Tuple{CosSquarePulse,Real})
end
@testset "dphi: $dphi" for dphi in DPHIS
    test_mom = rand(RNG,SFourMomentum)
    test_pulse = CosSquarePulse(test_mom,dphi)

    @testset "properties" begin
        @test reference_momentum(test_pulse) == test_mom
        @test domain(test_pulse) == Interval(-dphi,dphi) # cos_square specific
        @test phase_duration(test_pulse) == dphi
    end

    @testset "envelope" begin
        # unity at the origin
        @test envelope(test_pulse,0.0) == 1.0

        # zero at the endpoints
        a,b = endpoints(domain(test_pulse))
        @test isapprox(envelope(test_pulse,a),zero(a),atol=ATOL,rtol=RTOL)
        @test isapprox(envelope(test_pulse,b),zero(b),atol=ATOL,rtol=RTOL)
    end
end
