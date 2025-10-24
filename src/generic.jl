### Generic implementations for plane-wave fields

# deligations
oscillator(field::AbstractPlaneWaveField, phi::Real) = oscillator(polarization(field), phi)
polarization_vector(field::AbstractPlaneWaveField) = polarization_vector(polarization(field), reference_momentum(field))

"""

    amplitude(field::AbstractPlaneWaveField, pol::AbstractDefinitePolarization, phi)

Returns the value of the amplitude for a given polarization direction and phase variable `phi`.

!!! note "Safe implementation"

    In this function, a domain check is performed, i.e. if `phi` is in the domain of the field,
    the value of the amplitude is returned, and zero otherwise.
"""
function amplitude(
        field::AbstractPlaneWaveField, pol::AbstractDefinitePolarization, phi::Real
    )
    return phi in domain(field) ? _amplitude(field, pol, phi) : zero(phi)
end

function amplitude(
        field::AbstractPlaneWaveField{P}, phi::Real,
    ) where {P <: AbstractDefinitePolarization}
    return phi in domain(field) ? _amplitude(field, phi) : zero(phi)
end

### internal integrals

function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T) where {T <: Real, P <: AbstractDefinitePolarization}
    tmp_func1 = t -> _amplitude(field, t)
    tmp_func2 = t -> _amplitude(field, t)^2

    res1 = integrate(method, tmp_func1, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return (I1 = res1, I2 = res2)
end

function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T) where {T <: Real, P <: AbstractIndefinitePolarization}
    tmp_func11 = t -> _amplitude(field, t, PolX())
    tmp_func12 = t -> _amplitude(field, t, PolY())
    tmp_func2 = t -> _amplitude(field, t, PolX())^2 + _amplitude(field, t, PolY())^2

    res11 = integrate(method, tmp_func11, zero(T), phi)
    res12 = integrate(method, tmp_func12, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return (I11 = res12, I12 = res12, I2 = res2)
end

function internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T)::@NamedTuple{I1::T, I2::T} where {T <: Real, P <: AbstractDefinitePolarization}

    dom = domain(field)

    if phi in dom
        res = _internal_integrals(field, method, phi)
    else
        res = phi <= minimum(dom) ? _internal_integrals(field, method, minimum(dom)) : _internal_integrals(field, method, maximum(dom))
    end

    return res
end

### non-linear Volkov phase

function _volkov_phase(
        field::AbstractBackgroundField{AbstractDefinitePolarization},
        method::AbstractIntegrationMethod,
        phi::Real,
        beta1::Real,
        beta2::Real
    )

    # add volkov phase for definite polarization
end

function _volkov_phase(
        field::AbstractBackgroundField{AbstractIndefinitePolarization},
        method::AbstractIntegrationMethod,
        phi::Real,
        beta11::Real,
        beta12::Real,
        beta2::Real
    )
    # add volkov phase for indefinite polarization

end
