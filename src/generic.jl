### Generic implementations for plane-wave fields

# TODO: move oscillator to pulsed plane wave field. (or oscillating fields as a subtype?)
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
    return InternalIntegrals(res1, res2)
end

# TODO: this needs to be tested
function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T) where {T <: Real, P <: AbstractIndefinitePolarization}
    tmp_func11 = t -> _amplitude(field, t, PolX())
    tmp_func12 = t -> _amplitude(field, t, PolY())
    tmp_func2 = t -> _amplitude(field, t, PolX())^2 + _amplitude(field, t, PolY())^2

    res11 = integrate(method, tmp_func11, zero(T), phi)
    res12 = integrate(method, tmp_func12, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return InternalIntegrals(res12, res12, res2)
end

function internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T)::InternalIntegrals{T} where {T <: Real, P <: AbstractDefinitePolarization}

    dom = domain(field)

    phi_eval = phi <= minimum(dom) ? minimum(dom) : min(phi, maximum(dom))
    return _internal_integrals(field, method, phi_eval)

end

### non-linear Volkov phase

function _volkov_phase(
        field::AbstractBackgroundField{<:AbstractDefinitePolarization},
        method::AbstractIntegrationMethod,
        phi::Real,
        beta1::Real,
        beta2::Real
    )

    max_amp = maximum_amplitude(field)

    ii = _internal_integrals(field, method, phi)

    # "-" comes from eps_BG*eps_BG
    return max_amp * beta1 * ii.I1 - max_amp^2 * beta2 * ii.I2
end

function volkov_phase(
        field::AbstractPlaneWaveField,
        method::AbstractIntegrationMethod,
        phi::T,
        beta1::T,
        beta2::T
    )::T where {T <: Real}

    dom = domain(field)

    if phi in dom
        res = _volkov_phase(field, method, phi, beta1, beta2)
    else
        res = phi <= minimum(dom) ? _volkov_phase(field, method, minimum(dom), beta1, beta2) : _volkov_phase(field, method, maximum(dom), beta1, beta2)
    end

    return res
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
