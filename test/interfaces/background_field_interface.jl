using QEDbase
using QEDfields
using Random
using IntervalSets

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

RND_DOMAIN = Interval(-rand(RNG),rand(RNG))

struct TestBGfield <:AbstractBackgroundField 
    mom::QEDbase.AbstractFourMomentum
end

QEDfields.reference_momentum(field::TestBGfield) = field.mom
QEDfields.domain(::TestBGfield) = RND_DOMAIN
QEDfields.phase_duration(::TestBGfield) = width(RNG_DOMAIN)
QEDfields._pulse_envelope(::TestBGfield,x::Real) = one(x)

@testset "default interface" begin
    rnd_mom = SFourMomentum(rand(RNG,4))
    test_field = TestBGfield(rnd_mom)
    @test reference_momentum(test_field)==rnd_mom
end
