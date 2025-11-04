using Random
using IntervalSets
using QEDcore
using QEDfields
using QuadGK

include("testutils.jl")

RNG = Xoshiro(161)
ATOL = 0.0
RTOL = sqrt(eps())
DTYPES = (Float32, Float64)

@testset "dtype = $dtype" for dtype in DTYPES

    DPHIS = [
        rand(RNG, dtype),
        rand(RNG, dtype) * 10,
        rand(RNG, dtype) * 100,
        rand(RNG, dtype) * 1000,
    ]

    INTEGRATION_METHODS = (GaussKronrodQuadrature(), GaussLegendreQuadrature(2000; dtype))
    INTEGRATION_METHODS_WITH_ANALYTIC = (INTEGRATION_METHODS..., Analytical())
    @testset "dphi: $dphi" for dphi in DPHIS

        @testset "Cos Square Pulse" begin
            pulse = CosSquarePulse(dphi)

            @test domain(pulse) == Interval(-dphi, dphi)
            _check_generic_pulse_properties(pulse, dphi)

            RND_PHI = rand(RNG, domain(pulse))
            @testset "$pol" for pol in (PolX(), PolY())
                @testset "$meth1 $meth2" for (meth1, meth2) in _unique_combinations(INTEGRATION_METHODS_WITH_ANALYTIC)
                    #_check_internal_integrals(pulse, pol, meth1, meth2, RND_PHI)
                end
            end
        end

        @testset "Gaussian Pulse" begin
            pulse = GaussianPulse(dphi)

            @test domain(pulse) == Interval(-Inf, Inf)
            _check_generic_pulse_properties(pulse, dphi)

            RND_PHI = rand(RNG, Interval(-3 * dphi, 3 * dphi))
            @show RND_PHI
            @testset "$pol" for pol in (PolX(), PolY())
                @testset "$meth1 $meth2" for (meth1, meth2) in _unique_combinations(INTEGRATION_METHODS)
                    _check_internal_integrals(pulse, pol, meth1, meth2, RND_PHI)
                end
            end
        end
    end
end
