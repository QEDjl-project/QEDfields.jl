@inline function _volkov_phase(
        internal_integral::InternalIntegral,
        phi::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    )
    beta1 = kinematic_factor1(internal_integral.field, p, p_prime) # = beta1*eps_BG
    beta2 = kinematic_factor2(internal_integral.field, p, p_prime) # = beta2 (without minus from eps_BG*eps_BG)

    return _volkov_phase(internal_integral, phi, beta1, beta2)
end

@inline function _volkov_phase(
        internal_integral::InternalIntegral,
        phi::Real,
        beta1::Real,
        beta2::Real
    )
    max_amp = maximum_amplitude(internal_integral.field)

    internal_int1 = _internal_integral1(internal_integral, phi)
    internal_int2 = _internal_integral2(internal_integral, phi)

    # "-" comes from eps_BG*eps_BG
    return max_amp * beta1 * internal_int1 - max_amp^2 * beta2 * internal_int2
end

### generic fallbacks for phase integrals

@inline function _volkov_phase(
        phase_integral::AbstractPhaseIntegral,
        phi::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    )

    return _volkov_phase(internal_integral(phase_integral), phi, p, p_prime)
end

@inline function _volkov_phase(
        phase_integral::AbstractPhaseIntegral,
        phi::Real,
        beta1::Real,
        beta2::Real
    )

    return _volkov_phase(internal_integral(phase_integral), phi, beta1, beta2)
end


# TODO:
# - maybe it is convenient to have a setup structure for Volkov phases instead of internal
# integrals: vp = VolkovPhase(field,method); vp(phi,beta1,beta2) and vp(phi,p,p_prime)
