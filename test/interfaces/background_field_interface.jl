using QEDbase
using QEDfields
using Random
using IntervalSets

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG,4))
RND_DOMAIN = Interval(-rand(RNG),rand(RNG))
RND_DOMAIN_WIDTH = width(RND_DOMAIN)
_groundtruth_envelope(x::Real) = one(x)
_groundtruth_envelope(x::AbstractVector) = ones(size(x))
_groundtruth_amplitude(::QEDfields.PolX, x) = cos(x)
_groundtruth_amplitude(::QEDfields.PolY, x) = sin(x)

struct TestBGfield <: AbstractPulsedPlaneWaveField end

QEDfields.reference_momentum(field::TestBGfield) = RND_MOM
QEDfields.domain(::TestBGfield) = RND_DOMAIN
QEDfields.phase_duration(::TestBGfield) = RND_DOMAIN_WIDTH 
QEDfields._pulse_envelope(::TestBGfield,x::Real) = one(x)

struct TestBGfieldFAIL <: AbstractPulsedPlaneWaveField end

@testset "hard interface" begin
    test_field = TestBGfield()
    @test reference_momentum(test_field)==RND_MOM
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
        rnd_phi = rand(RNG,RND_DOMAIN)
        @test isapprox(pulse_envelope(test_field,rnd_phi),_groundtruth_envelope(rnd_phi), atol = ATOL, rtol = RTOL)
        @test isapprox(pulse_envelope(test_field,leftendpoint(RND_DOMAIN)), _groundtruth_envelope(leftendpoint(RND_DOMAIN)), atol = ATOL, rtol = RTOL)
        @test isapprox(pulse_envelope(test_field,leftendpoint(RND_DOMAIN)-eps()), zero(Float64), atol = ATOL, rtol = RTOL)
        @test isapprox(pulse_envelope(test_field,rightendpoint(RND_DOMAIN)), _groundtruth_envelope(rightendpoint(RND_DOMAIN)), atol = ATOL, rtol = RTOL)
        @test isapprox(pulse_envelope(test_field,rightendpoint(RND_DOMAIN)+eps()), zero(Float64), atol = ATOL, rtol = RTOL)
    end
    @testset "compute vector" begin
        rnd_phis = rand(RNG,RND_DOMAIN, 2)
        push!(rnd_phis,leftendpoint(RND_DOMAIN))
        push!(rnd_phis,leftendpoint(RND_DOMAIN)-eps()) 
        push!(rnd_phis,rightendpoint(RND_DOMAIN))
        push!(rnd_phis,rightendpoint(RND_DOMAIN)+eps()) 

        test_envelope_values = pulse_envelope(test_field,rnd_phis)

        groundtruth_envelope_values = Vector{Float64}(undef,length(rnd_phis))
        for (idx,phi) in enumerate(rnd_phis)
            if phi in RND_DOMAIN
                groundtruth_envelope_values[idx] = _groundtruth_envelope(phi)
            else
                groundtruth_envelope_values[idx] = zero(phi)
            end
        end

        @test isapprox(test_envelope_values,groundtruth_envelope_values, atol = ATOL, rtol = RTOL)
    end
end

@testset "pulse amplitude" begin
    @testset "$pol" for pol in (QEDfields.PolX(), QEDfields.PolY())
        test_field = TestBGfield()

        @testset "compute single" begin
            rnd_phi = rand(RNG,RND_DOMAIN)
            @test isapprox(amplitude(test_field,pol,rnd_phi),_groundtruth_amplitude(pol,rnd_phi), atol = ATOL, rtol = RTOL)
            @test isapprox(amplitude(test_field,pol, leftendpoint(RND_DOMAIN)), _groundtruth_amplitude(pol,leftendpoint(RND_DOMAIN)) , atol = ATOL, rtol = RTOL)
            @test isapprox(amplitude(test_field,pol, leftendpoint(RND_DOMAIN)-eps()), zero(Float64), atol = ATOL, rtol = RTOL)
            @test isapprox(amplitude(test_field,pol, rightendpoint(RND_DOMAIN)), _groundtruth_amplitude(pol,rightendpoint(RND_DOMAIN)), atol = ATOL, rtol = RTOL)
            @test isapprox(amplitude(test_field,pol, rightendpoint(RND_DOMAIN)+eps()), zero(Float64), atol = ATOL, rtol = RTOL)
        end

        @testset "compute vector" begin
            @test false
        end
    end
end
@testset "generic spectrum" begin
    @testset "$pol" for pol in (QEDfields.PolX(), QEDfields.PolY())
        test_field = TestBGfield()

        @testset "compute single" begin
            @test false
        end

        @testset "compute vector" begin
            @test false
        end
    end
end
