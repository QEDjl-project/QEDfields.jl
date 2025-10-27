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

_groundtruth_internal_integals(phi::T, ::PolX) where {T <: Real} = InternalIntegrals(phi^2 / 2, phi^3 / 3)
_groundtruth_internal_integals(phi::T, ::PolY) where {T <: Real} = InternalIntegrals(phi^3 / 3, phi^5 / 5)
function _groundtruth_internal_integral_endpoint(phi, pol)
    if phi <= minimum(RND_DOMAIN)
        return _groundtruth_internal_integals(minimum(RND_DOMAIN), pol)
    else
        return _groundtruth_internal_integals(maximum(RND_DOMAIN), pol)
    end
end
function _groundtruth_volkov_phase(f::TestPlaneWaveField, phi::T, beta1::T, beta2::T) where {T}
    ii = _groundtruth_internal_integals(phi, f.pol)
    max_ampl = f.a0 / ELEMENTARY_CHARGE
    return max_ampl * beta1 * ii.I1.value - max_ampl^2 * beta2 * ii.I2.value
end
function _groundtruth_volkov_phase_endpoints(f::TestPlaneWaveField, phi, beta1, beta2)
    if phi <= minimum(RND_DOMAIN)
        return _groundtruth_volkov_phase(f, minimum(RND_DOMAIN), beta1, beta2)
    else
        return _groundtruth_volkov_phase(f, maximum(RND_DOMAIN), beta1, beta2)
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

    @testset "generics" begin
        @test polarization_type(test_field) == typeof(pol)
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

    @testset "non-linear volkov phase" begin
        PHIS = (-rand(RNG), rand(RNG), minimum(RND_DOMAIN) - rand(RNG), maximum(RND_DOMAIN) + rand(RNG), 0.0, -0.0, Inf, -Inf)
        BETAS = (-rand(RNG), rand(RNG), 0.0, -0.0)
        @testset "method = $method" for method in INTEG_METHODS
            @testset "phi = $phi" for phi in PHIS
                @testset "beta0 = $beta1, beta2 = $beta2" for (beta1, beta2) in Iterators.product(BETAS, BETAS)
                    value = @inferred volkov_phase(test_field, method, phi, beta1, beta2)
                    groundtruth = phi in RND_DOMAIN ? _groundtruth_volkov_phase(test_field, phi, beta1, beta2) : _groundtruth_volkov_phase_endpoints(test_field, phi, beta1, beta2)

                    @test isapprox(value, groundtruth)
                end
            end
        end
    end
end
