### Generic implementations for plane-wave fields

# deligations
oscillator(field::AbstractPlaneWaveField, phi::Real) = oscillator(polarization(field), phi)
polarization_vector(field::AbstractPlaneWaveField) = polarization_vector(polarization(field), reference_momentum(field))

### internal integrals

function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractInternalIntegralMethod, phi::T) where {T <: Real, P <: AbstractDefinitePolarization}
    tmp_func1 = t -> _amplitude(field, t)
    tmp_func2 = t -> _amplitude(field, t)^2

    res1 = integrate(method, tmp_func1, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return (I1 = res1, I2 = res2)
end

function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractInternalIntegralMethod, phi::T) where {T <: Real, P <: AbstractIndefinitePolarization}
    tmp_func11 = t -> _amplitude(field, t, PolX())
    tmp_func12 = t -> _amplitude(field, t, PolY())
    tmp_func2 = t -> _amplitude(field, t, PolX())^2 + _amplitude(field, t, PolY())^2

    res11 = integrate(method, tmp_func11, zero(T), phi)
    res12 = integrate(method, tmp_func12, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return (I11 = res12, I12 = res12, I2 = res2)
end

function internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractInternalIntegralMethod, phi::T) where {T <: Real, P <: AbstractDefinitePolarization}

    dom = _domain(field)

    if phi in dom
        res = _internal_integrals(field, method, phi)
    else
        fac = phi <= minimum(dom) ? -one(phi) : one(phi)
        res = fac .* _internal_integrals(field, method, maximum(dom))
    end

    return res
end

### non-linear Volkov phase

function _volkov_phase(
        field::AbstractBackgroundField{DefinitePolarization},
        method::AbstractInternalIntegralMethod,
        phi::Real,
        beta1::Real,
        beta2::Real
    )

    # add volkov phase for definite polarization
end

function _volkov_phase(
        field::AbstractBackgroundField{IndefinitePolarization},
        method::AbstractInternalIntegralMethod,
        phi::Real,
        beta11::Real,
        beta12::Real,
        beta2::Real
    )
    # add volkov phase for indefinite polarization

end
