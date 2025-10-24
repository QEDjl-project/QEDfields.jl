using QEDcore
using QEDfields

using Random
using IntervalSets

RNG = Xoshiro(137)
ATOL = 0.0
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG, 4))
RND_A0 = rand(RNG)
RND_DOMAIN = ClosedInterval(-rand(RNG), rand(RNG))
INTEG_METHODS = (GaussKronrodQuadrature(), GaussLegendreQuadrature(20))

struct TestPlaneWaveField{T, P} <: AbstractPlaneWaveField{P}
    a0::T
    pol::P
end

_groundtruth_amplitude(phi, ::PolX) = phi
_groundtruth_amplitude(phi, ::PolY) = phi^2

_groundtruth_internal_integals(phi::T, ::PolX) where {T <: Real} = (I1 = phi^2 / 2, I2 = phi^3 / 3)
_groundtruth_internal_integals(phi::T, ::PolY) where {T <: Real} = (I1 = phi^3 / 3, I2 = phi^5 / 5)
function _groundtruth_internal_integral_endpoint(phi, pol)
    if phi <= minimum(RND_DOMAIN)
        return _groundtruth_internal_integals(minimum(RND_DOMAIN), pol)
    else
        return _groundtruth_internal_integals(maximum(RND_DOMAIN), pol)
    end
end

QEDfields._amplitude(field::TestPlaneWaveField, pol, phi::Real) = _groundtruth_amplitude(phi, pol)
QEDfields.domain(field::TestPlaneWaveField) = RND_DOMAIN
QEDfields.reference_momentum(field::TestPlaneWaveField) = RND_MOM
QEDfields.classical_nonlinearity_parameter(f::TestPlaneWaveField) = f.a0
QEDfields.polarization(f::TestPlaneWaveField) = f.pol

struct TestPolarization <: AbstractPolarization end
struct TestPlaneWaveFieldFAIL <: AbstractPlaneWaveField{TestPolarization} end

@testset "failed interface" begin
    test_field_FAIL = TestPlaneWaveFieldFAIL()
    phi = rand(RNG)
    @test_throws MethodError QEDfields._amplitude(test_field_FAIL, PolX(), phi)
    @test_throws MethodError QEDfields._amplitude(test_field_FAIL, PolY(), phi)
    @test_throws MethodError reference_momentum(test_field_FAIL)
    @test_throws MethodError domain(test_field_FAIL)
    @test_throws MethodError pulse_length(test_field_FAIL)
end

# TODO: add tests for elliptic polarization
@testset "$pol" for pol in (PolX(), PolY())

    test_field = TestPlaneWaveField(RND_A0, pol)
    @testset "hard interface" begin
        @test reference_momentum(test_field) == RND_MOM
        @test classical_nonlinearity_parameter(test_field) == RND_A0
        @test a0_parameter(test_field) == RND_A0
        @test polarization(test_field) == pol
    end

    @testset "maximum amplitude" begin
        value = @inferred maximum_amplitude(test_field)
        groundtruth = RND_A0 / ELEMENTARY_CHARGE

        @test isapprox(value, groundtruth)
    end

    @testset "amplitude function" begin
        PHIS = (-rand(RNG), rand(RNG), minimum(RND_DOMAIN) - rand(RNG), maximum(RND_DOMAIN) + rand(RNG), 0.0, -0.0, Inf, -Inf)

        @testset "phi = $phi" for phi in PHIS
            value = @inferred amplitude(test_field, pol, phi)
            value_default = @inferred amplitude(test_field, phi)
            groundtruth = phi in RND_DOMAIN ? _groundtruth_amplitude(phi, pol) : zero(phi)

            @test isapprox(value, groundtruth)
            @test isapprox(value_default, groundtruth)
        end
    end

    @testset "internal integral" begin
        PHIS = (-rand(RNG), rand(RNG), minimum(RND_DOMAIN) - rand(RNG), maximum(RND_DOMAIN) + rand(RNG), 0.0, -0.0, Inf, -Inf)
        @testset "method = $method" for method in INTEG_METHODS
            @testset "phi = $phi" for phi in PHIS
                value = @inferred internal_integrals(test_field, method, phi)
                groundtruth = phi in RND_DOMAIN ? _groundtruth_internal_integals(phi, pol) : _groundtruth_internal_integral_endpoint(phi, pol)

                @test isapprox(value.I1, groundtruth.I1)
                @test isapprox(value.I2, groundtruth.I2)
            end
        end
    end
end
