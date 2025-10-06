#### generic fallbacks

"""

    integral_B1(::PhaseIntegral,pnum,p,p_prime)

"""
function integral_B1(
        phase_integral::AbstractPhaseIntegral{P},
        pnum::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    ) where {
        P <: AbstractPulsedPlaneWaveField,
    }

    beta1 = kinematic_factor1(background_field(phase_integral), p, p_prime) # = beta1*eps_BG
    beta2 = kinematic_factor2(background_field(phase_integral), p, p_prime) # = beta2 (without minus from eps_BG*eps_BG)

    return integral_B1(phase_integral, pnum, beta1, beta2)
end


"""

    integral_B2(::PhaseIntegral,pnum,p,p_prime)

"""
function integral_B2(
        phase_integral::AbstractPhaseIntegral{P},
        pnum::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    ) where {
        P <: AbstractPulsedPlaneWaveField,
    }
    beta1 = kinematic_factor1(background_field(phase_integral), p, p_prime) # = beta1*eps_BG
    beta2 = kinematic_factor2(background_field(phase_integral), p, p_prime) # = beta2 (without minus from eps_BG*eps_BG)

    return integral_B2(phase_integral, pnum, beta1, beta2)
end
