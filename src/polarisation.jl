

@inline polarisation_vector(pol::AbstractDefinitePolarization, mom) = _photon_state(pol, mom)
@inline polarisation_vector(pol::AbstractIndefinitePolarization, mom) = _photon_state(mom)

@inline _oscillator(::PolX, x) = cos(x)
@inline _oscillator(::PolY, x) = sin(x)  
@inline _oscillator(x) = (cos(x),sin(x))
@inline _oscillator(::AbstractIndefinitePolarization,x) = _oscillator(x)
