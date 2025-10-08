using QEDcore
using QEDfields

using Random
using IntervalSets

RNG = Xoshiro(137)
ATOL = 0.0
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG, 4))
RND_A0 = rand(RNG)

struct TestPlaneWaveField{P} <: AbstractPlaneWaveField
    pol::P
end

QEDfields.reference_momentum(field::TestPlaneWaveField) = RND_MOM
QEDfields.classical_nonlinearity_parameter(::TestPlaneWaveField) = RND_A0
QEDfields.polarization(f::TestPlaneWaveField) = f.pol

struct TestPlaneWaveFieldFAIL <: AbstractPlaneWaveField end

@testset "failed interface" begin
    test_field_FAIL = TestPlaneWaveFieldFAIL()
    @test_throws MethodError reference_momentum(test_field_FAIL)
    @test_throws MethodError domain(test_field_FAIL)
    @test_throws MethodError pulse_length(test_field_FAIL)
end


@testset "$pol" for pol in (PolX(), PolY())

    test_field = TestPlaneWaveField(pol)
    @testset "hard interface" begin
        @test reference_momentum(test_field) == RND_MOM
        @test classical_nonlinearity_parameter(test_field) == RND_A0
        @test a0_parameter(test_field) == RND_A0
        @test polarization(test_field) == pol
    end

    @testset "maximum amplitude" begin
        @test maximum_amplitude(test_field) == RND_A0 / ELEMENTARY_CHARGE
    end
end
