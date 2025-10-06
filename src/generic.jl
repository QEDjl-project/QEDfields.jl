### Generic implementations for plane-wave fields

# deligations
oscillator(field::AbstractPlaneWaveField, phi::Real) = oscillator(polarization(field), phi)
polarization_vector(field::AbstractPlaneWaveField) = polarization_vector(polarization(field), reference_momentum(field))
