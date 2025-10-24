struct VolkovPhase{
        I1 <: AbstractUnivariateInternalIntegral,
        I2 <: AbstractBivariateInternalIntegral,
    }
    internal_integral1::I1
    internal_integral2::I2
end

_internal_integral1(volkov_phase::VolkovPhase) = volkov_phase.internal_integral1
_internal_integral2(volkov_phase::VolkovPhase) = volkov_phase.internal_integral2
