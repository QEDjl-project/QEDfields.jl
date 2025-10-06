### generic fallbacks for fields

# TODO: make this an interface for general BG fields and a special inplementation for PPW
@inline function _internal_integral1(
        field::AbstractBackgroundField,
        method::AbstractIntegrationMethod,
        phi::Real
    )
    return _internal_integral1(
        pulse_profile(field),
        polarization(field),
        method,
        phi
    )
end

# TODO: make this an interface for general BG fields and a special inplementation for PPW
@inline function _internal_integral2(
        field::AbstractBackgroundField,
        method::AbstractIntegrationMethod,
        phi::Real
    )

    return _internal_integral2(
        pulse_profile(field),
        polarization(field),
        method,
        phi
    )
end

@inline function _internal_integral1(internal_int::AbstractInternalIntegral, phi::Real)
    return _internal_integral1(
        background_field(internal_int),
        integration_method(internal_int),
        phi
    )
end

@inline function _internal_integral2(internal_int::AbstractInternalIntegral, phi::Real)
    return _internal_integral2(
        background_field(internal_int),
        integration_method(internal_int),
        phi
    )
end

### safe versions (for test purposes)

function internal_integral1(
        pulse::AbstractPulseProfile,
        pol::AbstractPolarization,
        method::AbstractIntegrationMethod,
        phi::Real
    )
    dom = domain(pulse)
    if phi in dom
        return _internal_integral1(pulse, pol, method, phi)
    end

    fac = phi <= minimum(dom) ? -one(phi) : one(phi)

    return fac * _internal_integral1(pulse, pol, method, maximum(dom))
end

@inline function internal_integral1(
        field::AbstractBackgroundField,
        method::AbstractIntegrationMethod,
        phi::Real
    )
    return _internal_integral1(
        pulse_profile(field),
        polarization(field),
        method,
        phi
    )
end

@inline function internal_integral1(internal_int::AbstractInternalIntegral, phi::Real)
    return internal_integral1(
        background_field(internal_int),
        integration_method(internal_int),
        phi
    )
end

function internal_integral2(
        pulse::AbstractPulseProfile,
        pol::AbstractPolarization,
        method::AbstractIntegrationMethod,
        phi::Real
    )
    dom = domain(pulse)
    if phi in dom
        return _internal_integral2(pulse, pol, method, phi)
    end

    fac = phi <= minimum(dom) ? -one(phi) : one(phi)

    return fac * _internal_integral2(pulse, pol, method, maximum(dom))
end

@inline function internal_integral2(
        field::AbstractBackgroundField,
        method::AbstractIntegrationMethod,
        phi::Real
    )
    return _internal_integral2(
        pulse_profile(field),
        polarization(field),
        method,
        phi
    )
end

@inline function internal_integral2(internal_int::AbstractInternalIntegral, phi::Real)
    return internal_integral2(
        background_field(internal_int),
        integration_method(internal_int),
        phi
    )
end
