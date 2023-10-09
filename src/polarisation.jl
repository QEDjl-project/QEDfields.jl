@inline polarisation_vector(pol::AbstractDefinitePolaristaion, mom) = base_state(Photon(), pol, mom)

@inline _oscillator(::PolX, x) = cos(x)
@inline _oscillator(::PolY, x) = sin(x)  
@inline _oscillator(::AbstractIndefinitePolarisaion, x) = (_oscillator(::PolX,phi),_oscillator(::PolY,phi))
