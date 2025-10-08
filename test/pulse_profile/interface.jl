using QEDbase
using QEDcore
using QEDfields

using Random
using IntervalSets

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

struct TestProfileFAIL <: AbstractPulseProfile end

@testset "failed interface" begin
    test_field_FAIL = TestProfileFAIL()
    @test_throws MethodError domain(test_field_FAIL)
    @test_throws MethodError pulse_length(test_field_FAIL)
    @test_throws MethodError envelope(test_field_FAIL)
end

@testset "properties" begin
    test_profile = TestProfile()
    @test domain(test_profile) == RND_DOMAIN
    @test pulse_length(test_profile) == RND_DOMAIN_WIDTH
end

@testset "pulse envelope" begin
    test_profile = TestProfile()

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
        envelope(test_profile, leftendpoint(RND_DOMAIN) - eps()),
        zero(Float64),
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
        envelope(test_profile, rightendpoint(RND_DOMAIN) + eps()),
        zero(Float64),
        atol = ATOL,
        rtol = RTOL,
    )
end
