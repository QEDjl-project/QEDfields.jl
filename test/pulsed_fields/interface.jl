using QEDbase
using QEDcore
using QEDfields

using Random
using IntervalSets

include("testutils.jl")

RNG = Xoshiro(137)
ATOL = 0.0
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG, 4))
RND_A0 = rand(RNG)

# Test profile: box profile
RND_DOMAIN = Interval(-rand(RNG), rand(RNG))
RND_DOMAIN_WIDTH = width(RND_DOMAIN)
_groundtruth_envelope(x) = one(x)

struct TestProfile <: AbstractPulseProfile end

QEDfields.domain(::TestProfile) = RND_DOMAIN
QEDfields.pulse_length(::TestProfile) = RND_DOMAIN_WIDTH
QEDfields._envelope(::TestProfile, x::Real) = one(x)

struct TestPulsedField{P} <: AbstractPulsedPlaneWaveField{P}
    pol::P
end

QEDfields.pulse_profile(::TestPulsedField) = TestProfile()
QEDfields.reference_momentum(field::TestPulsedField) = RND_MOM
QEDfields.classical_nonlinearity_parameter(::TestPulsedField) = RND_A0
QEDfields.polarization(f::TestPulsedField) = f.pol

_groundtruth_amplitude(::QEDbase.PolX, x) = cos(x)
_groundtruth_amplitude(::QEDbase.PolY, x) = sin(x)

@testset "$pol" for pol in (PolX(), PolY())

    test_field = TestPulsedField(pol)
    @testset "hard interface" begin
        @test reference_momentum(test_field) == RND_MOM
        @test domain(test_field) == RND_DOMAIN
        @test pulse_length(test_field) == RND_DOMAIN_WIDTH
        @test classical_nonlinearity_parameter(test_field) == RND_A0
        @test a0_parameter(test_field) == RND_A0
        @test polarization(test_field) == pol
        @test pulse_profile(test_field) == TestProfile()
    end


    @testset "pulse envelope" begin

        rnd_phi = rand(RNG, RND_DOMAIN)
        @test isapprox(
            envelope(test_field, rnd_phi),
            _groundtruth_envelope(rnd_phi),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_field, leftendpoint(RND_DOMAIN)),
            _groundtruth_envelope(leftendpoint(RND_DOMAIN)),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_field, leftendpoint(RND_DOMAIN) - eps()),
            zero(Float64),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_field, rightendpoint(RND_DOMAIN)),
            _groundtruth_envelope(rightendpoint(RND_DOMAIN)),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_field, rightendpoint(RND_DOMAIN) + eps()),
            zero(Float64),
            atol = ATOL,
            rtol = RTOL,
        )
    end

    @testset "pulse amplitude" begin
        @testset "compute" begin
            rnd_phi = rand(RNG, RND_DOMAIN)
            @test isapprox(
                amplitude(test_field, rnd_phi),
                _groundtruth_amplitude(pol, rnd_phi),
                atol = ATOL,
                rtol = RTOL,
            )
            @test isapprox(
                amplitude(test_field, leftendpoint(RND_DOMAIN)),
                _groundtruth_amplitude(pol, leftendpoint(RND_DOMAIN)),
                atol = ATOL,
                rtol = RTOL,
            )
            @test isapprox(
                amplitude(test_field, leftendpoint(RND_DOMAIN) - eps()),
                zero(Float64),
                atol = ATOL,
                rtol = RTOL,
            )
            @test isapprox(
                amplitude(test_field, rightendpoint(RND_DOMAIN)),
                _groundtruth_amplitude(pol, rightendpoint(RND_DOMAIN)),
                atol = ATOL,
                rtol = RTOL,
            )
            @test isapprox(
                amplitude(test_field, rightendpoint(RND_DOMAIN) + eps()),
                zero(Float64),
                atol = ATOL,
                rtol = RTOL,
            )
        end
    end

    #=
    @testset "generic spectrum" begin
        @testset "compute" begin
            @testset "pnum = $l_test" for l_test in (
                1 + (0.1 * rand(RNG)), 1 - (0.1 * rand(RNG)), 1.0, 0.0,
            )
                @test isapprox(
                    generic_spectrum(test_field, pol, l_test),
                    _groundtruth_generic_spectrum(pol, l_test),
                    atol = ATOL,
                    rtol = RTOL,
                )
            end
        end
    end
    =#
end
