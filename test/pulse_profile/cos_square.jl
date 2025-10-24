# TODO
# - unify this test for all implemented pulse shapes
# - consider implementing a `DefaultPulseWrapper` which just wraps an existing pulse to
# test its analytical solution against the generic numerical ones.
# - this wrapper type should be stored in some `TestUtils`, maybe as an ext


using Random
using IntervalSets
using QEDbase
using QEDcore
using QEDfields
using QuadGK

RNG = Xoshiro(161)
ATOL = 0.0
RTOL = sqrt(eps())

DPHIS = [rand(RNG), rand(RNG) * 10, rand(RNG) * 100, rand(RNG) * 1000, rand(RNG) * 10000]

@testset "pulse interface" begin
    @test hasmethod(domain, Tuple{CosSquarePulse})
    @test hasmethod(pulse_length, Tuple{CosSquarePulse})
    @test hasmethod(QEDfields._envelope, Tuple{CosSquarePulse, Real})
end
@testset "dphi: $dphi" for dphi in DPHIS
    test_pulse = CosSquarePulse(dphi)

    @testset "properties" begin
        @test domain(test_pulse) == Interval(-dphi, dphi) # cos_square specific
        @test pulse_length(test_pulse) == dphi
    end

    @testset "envelope" begin
        # unity at the origin
        @test envelope(test_pulse, 0.0) == 1.0

        # zero at the endpoints
        @test isapprox(envelope(test_pulse, -Inf), 0.0, atol = ATOL, rtol = RTOL)
        @test isapprox(envelope(test_pulse, Inf), 0.0, atol = ATOL, rtol = RTOL)
    end
end
