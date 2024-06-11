using Random
using IntervalSets
using QEDfields
using QEDbase
using QuadGK

RNG = MersenneTwister(123456789)
ATOL = 0.0
RTOL = sqrt(eps())

DPHIS = [rand(RNG), rand(RNG) * 10, rand(RNG) * 100, rand(RNG) * 1000, rand(RNG) * 10000]

# wrapper implementation to test analytical solutions of the generic spectrum

struct CosSquarePulseWrapper{C<:CosSquarePulse} <: AbstractPulsedPlaneWaveField
    pulse::C
end
QEDfields.reference_momentum(p::CosSquarePulseWrapper) = reference_momentum(p.pulse)
QEDfields.domain(p::CosSquarePulseWrapper) = domain(p.pulse)
QEDfields.phase_duration(p::CosSquarePulseWrapper) = phase_duration(p.pulse)
QEDfields._envelope(p::CosSquarePulseWrapper, x) = QEDfields._envelope(p.pulse, x)

@testset "pulse interface" begin
    @test hasmethod(reference_momentum, Tuple{CosSquarePulse})
    @test hasmethod(domain, Tuple{CosSquarePulse})
    @test hasmethod(phase_duration, Tuple{CosSquarePulse})
    @test hasmethod(QEDfields._envelope, Tuple{CosSquarePulse,Real})
end
@testset "dphi: $dphi" for dphi in DPHIS
    test_mom = rand(RNG, SFourMomentum)
    test_pulse = CosSquarePulse(test_mom, dphi)

    @testset "properties" begin
        @test reference_momentum(test_pulse) == test_mom
        @test domain(test_pulse) == Interval(-dphi, dphi) # cos_square specific
        @test phase_duration(test_pulse) == dphi
    end

    @testset "envelope" begin
        # unity at the origin
        @test envelope(test_pulse, 0.0) == 1.0

        # zero at the endpoints
        @test isapprox(envelope(test_pulse, -Inf), 0.0, atol=ATOL, rtol=RTOL)
        @test isapprox(envelope(test_pulse, Inf), 0.0, atol=ATOL, rtol=RTOL)
    end
    @testset "generic spectrum" begin
        wrapper_pulse = CosSquarePulseWrapper(test_pulse)
        test_pnums = [1.0, -1.0, 1 + rand(RNG) * 0.1, -1 - rand(RNG) * 0.1]
        @testset "pnum: $pnum" for pnum in test_pnums
            test_val_xpol = generic_spectrum(test_pulse, PolX(), pnum)
            test_val_ypol = generic_spectrum(test_pulse, PolY(), pnum)

            groundtruth_xpol = generic_spectrum(wrapper_pulse, PolX(), pnum)
            groundtruth_ypol = generic_spectrum(wrapper_pulse, PolY(), pnum)

            @test isapprox(test_val_xpol, groundtruth_xpol, atol=ATOL, rtol=RTOL)
            @test isapprox(test_val_ypol, groundtruth_ypol, atol=ATOL, rtol=RTOL)
        end
    end
end
