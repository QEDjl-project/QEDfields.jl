### standard implementation for a pulsed plane-wave field for arbitrary pulse profiles


"""

    PulsedPlaneWaveField(
        pulse::AbstractPulseProfile,
        mom::AbstractFourMomentum,
        a0::Real,
        pol::AbstractPolarization
    )

"""
struct PulsedPlaneWaveField{P <: AbstractPulseProfile, POL <: AbstractPolarization, T <: Real, MOM <: AbstractFourMomentum} <: AbstractPulsedPlaneWaveField
    pulse::P
    mom::MOM
    a0::T
    pol::POL
end

reference_momentum(field::PulsedPlaneWaveField) = field.mom
classical_nonlinearity_parameter(field::PulsedPlaneWaveField) = field.a0
polarization(field::PulsedPlaneWaveField) = field.pol
pulse_profile(field::PulsedPlaneWaveField) = field.pulse

# aliasses
const CosSquareField{POL, T, MOM} = PulsedPlaneWaveField{P, POL, T, MOM} where {T, P <: CosSquarePulse{T}}
const GaussianField{POL, T, MOM} = PulsedPlaneWaveField{P, POL, T, MOM} where {T, P <: GaussianPulse{T}}
