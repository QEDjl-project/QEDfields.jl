# TODO: consider swap field and volkov phase in the arguemnts

@inline function _compute(
        field::AbstractBackgroundField,
        volkov_phase::AbstractVolkovPhase,
        phi::Real,
        beta1::Real,
        beta2::Real
    )
    max_amp = maximum_amplitude(field)

    internal_int1 = _compute(_internal_integral1(volkov_phase), field, phi)
    internal_int2 = _compute(_internal_integral2(volkov_phase), field, phi)

    # "-" comes from eps_BG*eps_BG
    return max_amp * beta1 * internal_int1 - max_amp^2 * beta2 * internal_int2
end

@inline function _compute(
        volkov_phase::AbstractVolkovPhase,
        phi::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    )
    beta1 = kinematic_factor1(internal_integral.field, p, p_prime) # = beta1*eps_BG
    beta2 = kinematic_factor2(internal_integral.field, p, p_prime) # = beta2 (without minus from eps_BG*eps_BG)

    return _compute(field, volkov_phase, phi, beta1, beta2)
end
