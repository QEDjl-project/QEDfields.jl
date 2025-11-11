_unique_combinations(a1, a2) = unique(Set, Iterators.filter(allunique, Iterators.product(a1, a2)))
_unique_combinations(a) = _unique_combinations(a, a)

function _check_pulse_interface(::Type{P}) where {P <: AbstractPulseProfile}
    @test hasmethod(domain, Tuple{P})
    @test hasmethod(pulse_length, Tuple{P})
    @test hasmethod(QEDfields._envelope, Tuple{P, Real})

    return nothing
end

function _check_pulse_properties(pulse, dphi)
    dom = domain(pulse)
    @test dom isa AbstractInterval
    @test pulse_length(pulse) == dphi

    return nothing
end

function _check_pulse_envelope(pulse, ::Type{T}) where {T}

    # unity at the origin
    @test envelope(pulse, zero(T)) == one(T)

    # zero at the endpoints
    @test isapprox(envelope(pulse, -T(Inf)), zero(T), atol = ATOL, rtol = RTOL)
    @test isapprox(envelope(pulse, T(Inf)), zero(T), atol = ATOL, rtol = RTOL)

    return nothing
end

function _check_generic_pulse_properties(pulse::P, dphi::T) where {P <: AbstractPulseProfile, T <: Real}
    @testset "pulse interface" _check_pulse_interface(P)
    @testset "properties" _check_pulse_properties(pulse, dphi)
    @testset "envelope" _check_pulse_envelope(pulse, T)

    return nothing
end

function _check_internal_integrals(
        pulse::AbstractPulseProfile,
        pol::AbstractDefinitePolarization,
        method1,
        method2,
        phi
    )
    integrals1 = QEDfields._internal_integrals(pulse, pol, method1, phi)
    integrals2 = QEDfields._internal_integrals(pulse, pol, method2, phi)

    @test isapprox(integrals1.I1, integrals2.I1, rtol = 0.001)
    @test isapprox(integrals1.I2, integrals2.I2, rtol = 0.01)

    return
end
