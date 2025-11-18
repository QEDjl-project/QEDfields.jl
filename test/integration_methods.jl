# TODO:
# - unify tests for all methods
# - think about analytical tests


using QEDfields

using Random
using IntervalSets

RNG = Xoshiro(137)
ATOL = 0.0
RTOL = sqrt(eps())

_test_integrand(x) = sin(x)
_groundtruth(a, b) = cos(a) - cos(b)

LIMITS = (-rand(RNG), rand(RNG))

@testset "Gauss-Kronrod" begin
    method = GaussKronrodQuadrature()
    test_res = integrate(method, _test_integrand, LIMITS...)

    @test isapprox(test_res, _groundtruth(LIMITS...))
end

@testset "Gauss-Legendre" begin
    method = GaussLegendreQuadrature(20)
    test_res = integrate(method, _test_integrand, LIMITS...)

    @test isapprox(test_res, _groundtruth(LIMITS...))
end
