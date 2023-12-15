using QEDbase
using QEDfields
using Random
using IntervalSets

RNG = MersenneTwister(137)
ATOL = 0.0
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG, 4))

# Test pulse: box profile
RND_DOMAIN = Interval(-rand(RNG), rand(RNG))
RND_DOMAIN_WIDTH = width(RND_DOMAIN)
_groundtruth_envelope(x::Real) = one(x)
_groundtruth_envelope(x::AbstractVector) = ones(size(x))
_groundtruth_amplitude(::QEDfields.PolX, x) = cos(x)
_groundtruth_amplitude(::QEDfields.PolY, x) = sin(x)

function _indefinite_integral(::QEDfields.PolX, x, l)
    # according to wolframalpha.com
    if l == zero(l)
        return sin(x)
    elseif l == one(l)
        # integral cos(x) e^(i x) dx = x/2 - 1/4 i e^(2 i x) + constant
        return 0.5 * (x - 0.5im * exp(2im * x))
    else
        # integral cos(x) e^(i l x) dx = -(i e^(i l x) (l cos(x) - i sin(x)))/(l^2 - 1) + constant
        return -1im * exp(1im * x * l) * (l * cos(x) - 1im * sin(x)) / (l^2 - 1)
    end
end

function _indefinite_integral(::QEDfields.PolY, x, l)
    # according to wolframalpha.com
    if l == zero(l)
        return -cos(x)
    elseif l == one(l)
        # integral sin(x) e^(i x) dx = (i x)/2 - 1/4 e^(2 i x) + constant
        return 0.5 * (1im * x - 0.5 * exp(2im * x))
    else
        # integral sin(x) e^(i l x) dx = (e^(i l x) (cos(x) - i l sin(x)))/(l^2 - 1) + constant
        return exp(1im * x * l) * (cos(x) - 1im * l * sin(x)) / (l^2 - 1)
    end
end

function _groundtruth_generic_spectrum(pol, l)
    return _indefinite_integral(pol, rightendpoint(RND_DOMAIN), l) -
           _indefinite_integral(pol, leftendpoint(RND_DOMAIN), l)
end

struct TestBGfield <: AbstractPulsedPlaneWaveField end

QEDfields.reference_momentum(field::TestBGfield) = RND_MOM
QEDfields.domain(::TestBGfield) = RND_DOMAIN
QEDfields.phase_duration(::TestBGfield) = RND_DOMAIN_WIDTH
QEDfields._envelope(::TestBGfield, x::Real) = one(x)

struct TestBGfieldFAIL <: AbstractPulsedPlaneWaveField end

@testset "hard interface" begin
    test_field = TestBGfield()
    @test reference_momentum(test_field) == RND_MOM
    @test domain(test_field) == RND_DOMAIN
    @test phase_duration(test_field) == RND_DOMAIN_WIDTH
end

@testset "failed interface" begin
    test_field_FAIL = TestBGfieldFAIL()
    @test_throws MethodError reference_momentum(test_field_FAIL)
    @test_throws MethodError domain(test_field_FAIL)
    @test_throws MethodError phase_duration(test_field_FAIL)
end

@testset "pulse envelope" begin
    test_field = TestBGfield()

    @testset "compute single" begin
        rnd_phi = rand(RNG, RND_DOMAIN)
        @test isapprox(
            envelope(test_field, rnd_phi),
            _groundtruth_envelope(rnd_phi),
            atol=ATOL,
            rtol=RTOL,
        )
        @test isapprox(
            envelope(test_field, leftendpoint(RND_DOMAIN)),
            _groundtruth_envelope(leftendpoint(RND_DOMAIN)),
            atol=ATOL,
            rtol=RTOL,
        )
        @test isapprox(
            envelope(test_field, leftendpoint(RND_DOMAIN) - eps()),
            zero(Float64),
            atol=ATOL,
            rtol=RTOL,
        )
        @test isapprox(
            envelope(test_field, rightendpoint(RND_DOMAIN)),
            _groundtruth_envelope(rightendpoint(RND_DOMAIN)),
            atol=ATOL,
            rtol=RTOL,
        )
        @test isapprox(
            envelope(test_field, rightendpoint(RND_DOMAIN) + eps()),
            zero(Float64),
            atol=ATOL,
            rtol=RTOL,
        )
    end

    @testset "compute vector" begin
        rnd_phis = rand(RNG, RND_DOMAIN, 2)
        push!(rnd_phis, leftendpoint(RND_DOMAIN))
        push!(rnd_phis, leftendpoint(RND_DOMAIN) - eps())
        push!(rnd_phis, rightendpoint(RND_DOMAIN))
        push!(rnd_phis, rightendpoint(RND_DOMAIN) + eps())

        test_envelope_values = envelope(test_field, rnd_phis)

        groundtruth_envelope_values = -ones(Float64, length(rnd_phis))
        for (idx, phi) in enumerate(rnd_phis)
            if phi in RND_DOMAIN
                groundtruth_envelope_values[idx] = _groundtruth_envelope(phi)
            else
                groundtruth_envelope_values[idx] = zero(phi)
            end
        end

        @test isapprox(
            test_envelope_values, groundtruth_envelope_values, atol=ATOL, rtol=RTOL
        )
    end
end

@testset "pulse amplitude" begin
    @testset "$pol" for pol in (QEDfields.PolX(), QEDfields.PolY())
        test_field = TestBGfield()

        @testset "compute single" begin
            rnd_phi = rand(RNG, RND_DOMAIN)
            @test isapprox(
                amplitude(test_field, pol, rnd_phi),
                _groundtruth_amplitude(pol, rnd_phi),
                atol=ATOL,
                rtol=RTOL,
            )
            @test isapprox(
                amplitude(test_field, pol, leftendpoint(RND_DOMAIN)),
                _groundtruth_amplitude(pol, leftendpoint(RND_DOMAIN)),
                atol=ATOL,
                rtol=RTOL,
            )
            @test isapprox(
                amplitude(test_field, pol, leftendpoint(RND_DOMAIN) - eps()),
                zero(Float64),
                atol=ATOL,
                rtol=RTOL,
            )
            @test isapprox(
                amplitude(test_field, pol, rightendpoint(RND_DOMAIN)),
                _groundtruth_amplitude(pol, rightendpoint(RND_DOMAIN)),
                atol=ATOL,
                rtol=RTOL,
            )
            @test isapprox(
                amplitude(test_field, pol, rightendpoint(RND_DOMAIN) + eps()),
                zero(Float64),
                atol=ATOL,
                rtol=RTOL,
            )
        end

        @testset "compute vector" begin
            rnd_phis = rand(RNG, RND_DOMAIN, 2)
            push!(rnd_phis, leftendpoint(RND_DOMAIN))
            push!(rnd_phis, leftendpoint(RND_DOMAIN) - eps())
            push!(rnd_phis, rightendpoint(RND_DOMAIN))
            push!(rnd_phis, rightendpoint(RND_DOMAIN) + eps())

            test_amplitude_values = amplitude(test_field, pol, rnd_phis)

            groundtruth_amplitude_values = -2 * ones(Float64, length(rnd_phis))
            for (idx, phi) in enumerate(rnd_phis)
                if phi in RND_DOMAIN
                    groundtruth_amplitude_values[idx] = _groundtruth_amplitude(pol, phi)
                else
                    groundtruth_amplitude_values[idx] = zero(phi)
                end
            end

            @test isapprox(
                test_amplitude_values, groundtruth_amplitude_values, atol=ATOL, rtol=RTOL
            )
        end
    end
end

@testset "generic spectrum" begin
    @testset "$pol" for pol in (QEDfields.PolX(), QEDfields.PolY())
        test_field = TestBGfield()

        @testset "compute single" begin
            @testset "pnum = $l_test" for l_test in (
                1 + (0.1 * rand(RNG)), 1 - (0.1 * rand(RNG)), 1.0, 0.0
            )
                @test isapprox(
                    generic_spectrum(test_field, pol, l_test),
                    _groundtruth_generic_spectrum(pol, l_test),
                    atol=ATOL,
                    rtol=RTOL,
                )
            end
        end

        @testset "compute vector" begin
            l_test = [1.0, 0.0]
            push!(l_test, 1 + (0.1 * rand(RNG)))
            push!(l_test, 1 - (0.1 * rand(RNG)))
            test_generic_spectrum_values = generic_spectrum(test_field, pol, l_test)

            groundtruth_generic_spectrum_values =
                _groundtruth_generic_spectrum.(Ref(pol), l_test)

            @test isapprox(
                test_generic_spectrum_values,
                groundtruth_generic_spectrum_values,
                atol=ATOL,
                rtol=RTOL,
            )
        end
    end
end
