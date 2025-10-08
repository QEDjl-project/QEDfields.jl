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

# wrapper implementation to test analytical solutions
struct CosSquarePulseWrapper{C <: CosSquarePulse} <: AbstractPulsedPlaneWaveField
    pulse::C
end
QEDfields.domain(p::CosSquarePulseWrapper) = domain(p.pulse)
QEDfields.pulse_length(p::CosSquarePulseWrapper) = pulse_length(p.pulse)
QEDfields._envelope(p::CosSquarePulseWrapper, x) = QEDfields._envelope(p.pulse, x)

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

    # TODO: set in after refac
    #=
    @testset "generic spectrum" begin
        wrapper_pulse = CosSquarePulseWrapper(test_pulse)
        test_pnums = [1.0, -1.0, 1 + rand(RNG) * 0.1, -1 - rand(RNG) * 0.1]
        @testset "pnum: $pnum" for pnum in test_pnums
            test_val_xpol = generic_spectrum(test_pulse, QEDbase.PolX(), pnum)
            test_val_ypol = generic_spectrum(test_pulse, QEDbase.PolY(), pnum)

            groundtruth_xpol = generic_spectrum(wrapper_pulse, QEDbase.PolX(), pnum)
            groundtruth_ypol = generic_spectrum(wrapper_pulse, QEDbase.PolY(), pnum)

            @test isapprox(test_val_xpol, groundtruth_xpol, atol = ATOL, rtol = RTOL)
            @test isapprox(test_val_ypol, groundtruth_ypol, atol = ATOL, rtol = RTOL)
        end
    end
    =#
end
