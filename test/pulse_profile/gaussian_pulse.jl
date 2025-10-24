# TODO
# - unify this test for all implemented pulse shapes

using Random
using IntervalSets
using QEDbase
using QEDfields
using QuadGK

RNG = Xoshiro(161)
ATOL = 0.0
RTOL = sqrt(eps())

DPHIS = [rand(RNG), rand(RNG) * 10, rand(RNG) * 100, rand(RNG) * 1000, rand(RNG) * 10000]

@testset "pulse interface" begin
    @test hasmethod(domain, Tuple{GaussianPulse})
    @test hasmethod(pulse_length, Tuple{GaussianPulse})
    @test hasmethod(QEDfields._envelope, Tuple{GaussianPulse, Real})
end
@testset "dphi: $dphi" for dphi in DPHIS
    test_pulse = GaussianPulse(dphi)

    @testset "properties" begin
        @test domain(test_pulse) == Interval(-Inf, Inf)
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
