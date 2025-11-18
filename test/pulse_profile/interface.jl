using QEDbase
using QEDcore
using QEDfields

using Random
using IntervalSets

include("testutils.jl")

RNG = Xoshiro(137)
ATOL = 0.0
RTOL = sqrt(eps())
DTYPES = (Float16, Float32, Float64)

# failing test profile
struct TestProfileFAIL <: AbstractPulseProfile end

@testset "failed interface" begin
    test_field_FAIL = TestProfileFAIL()
    @test_throws MethodError domain(test_field_FAIL)
    @test_throws MethodError pulse_length(test_field_FAIL)
    @test_throws MethodError envelope(test_field_FAIL)
end

# Test profile: box profile
_groundtruth_envelope(x) = one(x)
struct TestProfile{D} <: AbstractPulseProfile
    dom::D
end

QEDfields.domain(p::TestProfile) = p.dom
QEDfields.pulse_length(p::TestProfile) = width(p.dom)
QEDfields._envelope(::TestProfile, x::Real) = one(x)

@testset "dtype=$dtype" for dtype in DTYPES

    RND_DOMAIN = Interval(-rand(RNG, dtype), rand(RNG, dtype))

    test_profile = TestProfile(RND_DOMAIN)

    @testset "properties" begin
        @test domain(test_profile) == RND_DOMAIN
        _check_generic_pulse_properties(test_profile, width(RND_DOMAIN))
    end

    @testset "pulse envelope" begin

        rnd_phi = rand(RNG, RND_DOMAIN)
        @test isapprox(
            envelope(test_profile, rnd_phi),
            _groundtruth_envelope(rnd_phi),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_profile, leftendpoint(RND_DOMAIN)),
            _groundtruth_envelope(leftendpoint(RND_DOMAIN)),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_profile, prevfloat(leftendpoint(RND_DOMAIN))),
            zero(dtype),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_profile, rightendpoint(RND_DOMAIN)),
            _groundtruth_envelope(rightendpoint(RND_DOMAIN)),
            atol = ATOL,
            rtol = RTOL,
        )
        @test isapprox(
            envelope(test_profile, nextfloat(rightendpoint(RND_DOMAIN))),
            zero(dtype),
            atol = ATOL,
            rtol = RTOL,
        )
    end
end
