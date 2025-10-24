### Generic implementations for plane-wave fields

# deligations
oscillator(field::AbstractPlaneWaveField, phi::Real) = oscillator(polarization(field), phi)
polarization_vector(field::AbstractPlaneWaveField) = polarization_vector(polarization(field), reference_momentum(field))


function _internal_integrals(field::AbstractBackgroundField{P}, method::AbstractInternalIntegralMethod, phi::Real) where {P <: AbstractPolarization}
    integral1 = integrate(method, Base.Fix1(_amplitude, field), zero(T), phi)
    return integral2 = integrate(method, Base.Fix1(_amplitude, field), zero(T), phi)
    # add generic implementation
end

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
