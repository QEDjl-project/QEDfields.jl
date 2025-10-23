# TODO:
# - build list of profiles automatically
# - maybe use `InteractiveTools.subtypes` for it


using Random
using IntervalSets
using QEDbase
using QEDcore
using QEDfields
using QuadGK

RNG = MersenneTwister(123456789)
ATOL = 0.0
RTOL = sqrt(eps())

DPHIS = [rand(RNG), rand(RNG) * 10, rand(RNG) * 100, rand(RNG) * 1000, rand(RNG) * 10000]
PROFILES = [CosSquarePulse, GaussianPulse]
POLS = [PolX(), PolY()]
A0 = rand(RNG)
MOM = SFourMomentum(rand(RNG, 4))


@testset "pulse: $profile" for profile in PROFILES
    @testset "dphi: $dphi" for dphi in DPHIS
        @testset "pol: $pol" for pol in POLS
            test_profile = profile(dphi)
            test_field = PulsedPlaneWaveField(test_profile, MOM, A0, pol)


            @testset "properties" begin
                @test reference_momentum(test_field) == MOM
                @test domain(test_field) == domain(test_profile)
                @test pulse_length(test_field) == pulse_length(test_profile)
                @test classical_nonlinearity_parameter(test_field) == A0
                @test a0_parameter(test_field) == A0
                @test polarization(test_field) == pol
                @test pulse_profile(test_field) == test_profile
            end

            # TODO: implement checks for envelopes and amplitudes
        end
    end
end
