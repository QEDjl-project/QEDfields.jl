# TODO: make this an interface for general BG fields and a special inplementation for PPW
@inline function _compute(
        integral::AbstractInternalIntegral,
        field::AbstractBackgroundField,
        phi::Real
    )
    return _compute(
        integral,
        pulse_profile(field),
        polarization(field),
        phi
    )
end

### save versions (for test purposes)

function compute(
        integral::AbstractUnivariateInternalIntegral,
        pulse::AbstractPulseProfile,
        pol::AbstractPolarization,
        phi::Real
    )
    dom = domain(pulse)
    if phi in dom
        return _compute(integral, pulse, pol, phi)
    end

    fac = phi <= minimum(dom) ? -one(phi) : one(phi)

    return fac * _compute(integral, pulse, pol, maximum(dom))
end

@inline function compute(
        integral::AbstractInternalIntegral,
        field::AbstractBackgroundField,
        phi::Real
    )
    return compute(
        integral,
        pulse_profile(field),
        polarization(field),
        phi
    )
end
