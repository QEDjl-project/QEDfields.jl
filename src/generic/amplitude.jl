### Generic implementations for plane-wave fields

# TODO: move oscillator to pulsed plane wave field. (or oscillating fields as a subtype?)
# delegations
oscillator(field::AbstractPlaneWaveField, phi::Real) = oscillator(polarization(field), phi)
polarization_vector(field::AbstractPlaneWaveField) = polarization_vector(polarization(field), reference_momentum(field))
polarization_vector(field::AbstractPlaneWaveField, pol::AbstractDefinitePolarization) = polarization_vector(polarization(pol), reference_momentum(field))

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
