# TODO:
# - build list of profiles automatically
# - maybe use `InteractiveTools.subtypes` for it


using Random
using IntervalSets
using QEDbase
using QEDcore
using QEDfields
using QuadGK

include("testutils.jl")

RNG = MersenneTwister(123456789)
ATOL = 0.0
RTOL = sqrt(eps())

DPHIS = [rand(RNG), rand(RNG) * 10]
PROFILES = [CosSquarePulse, GaussianPulse]
POLS = [PolX(), PolY()]
A0 = rand(RNG)
MOM = SFourMomentum(rand(RNG, 4))

INTERNAL_INTEGRATION_METHODS = (GaussLegendreQuadrature(1000),)
PHASE_INTEGRATION_METHODS = (GaussKronrodQuadrature(),)
# TODO: enable this again, if endpoint internal integrals are introduced for infinite
# domains
#PHASE_INTEGRATION_METHODS= (GaussKronrodQuadrature(),GaussLegendreQuadrature(1000))

@testset "pulse: $profile" for profile in PROFILES
    @testset "dphi: $dphi" for dphi in DPHIS
        @testset "pol: $pol" for pol in POLS
            test_profile = profile(dphi)
            test_field = PulsedPlaneWaveField(test_profile, MOM, A0, pol)


            @testset "properties" begin
                @test reference_momentum(test_field) == MOM
                @test domain(test_field) == domain(test_profile)
                @test compact_domain(test_field) == compact_domain(test_profile)
                @test pulse_length(test_field) == pulse_length(test_profile)
                @test classical_nonlinearity_parameter(test_field) == A0
                @test a0_parameter(test_field) == A0
                @test polarization(test_field) == pol
                @test pulse_profile(test_field) == test_profile
            end

            @testset "amplitude function" begin
                dom = compact_domain(test_profile)
                PHIS = (-rand(RNG), rand(RNG), minimum(dom) - rand(RNG), maximum(dom) + rand(RNG), 0.0, -0.0, Inf, -Inf)

                @testset "phi = $phi" for phi in PHIS
                    value = @inferred amplitude(test_field, pol, phi)
                    value_default = @inferred amplitude(test_field, phi)
                    groundtruth = phi in domain(test_field) ? oscillator(pol, phi) * envelope(test_field, phi) : zero(phi)

                    @test isapprox(value, groundtruth)
                end
            end

            @testset "internal integral" begin
                dom = compact_domain(test_profile)
                PHIS = (-rand(RNG), rand(RNG), minimum(dom) - rand(RNG), maximum(dom) + rand(RNG), 0.0, -0.0, Inf, -Inf)
                @testset "method = $method" for method in INTERNAL_INTEGRATION_METHODS
                    @testset "phi = $phi" for phi in PHIS
                        value = @inferred internal_integrals(test_field, method, phi)
                        groundtruth = internal_integrals(test_profile, pol, method, phi)


                        @test isapprox(value.I1, groundtruth.I1)
                        @test isapprox(value.I2, groundtruth.I2)
                    end
                end
            end
            @testset "phase integral" begin
                dom = compact_domain(test_profile)
                PNUMS = (-rand(RNG), rand(RNG))
                BETAS = (rand(RNG),)
                @testset "ii_method = $ii_method" for ii_method in INTERNAL_INTEGRATION_METHODS
                    @testset "pi_method = $pi_method" for pi_method in PHASE_INTEGRATION_METHODS
                        @testset "pnum = $pnum" for pnum in PNUMS
                            @testset "beta1 = $beta1, beta2 = $beta2" for (beta1, beta2) in Iterators.product(BETAS, BETAS)
                                value = @inferred phase_integrals(test_field, ii_method, pi_method, pnum, beta1, beta2)
                                groundtruth = _groundtruth_phase_integrals(
                                    test_field,
                                    ii_method,
                                    pi_method,
                                    pnum, beta1, beta2
                                )

                                @test isapprox(value.B1, groundtruth.B1)
                                @test isapprox(value.B2, groundtruth.B2)
                            end
                        end
                    end
                end
            end
            # TODO: implement checks for envelopes and amplitudes
        end
    end
end
