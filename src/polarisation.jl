abstract type AbstractPolarisation end

abstract type AbstractDefinitePolarisation <: AbstractPolarisation end

struct PolarisationX <: AbstractDefinitePolarisation end
const PolX = PolarisationX

struct PolarisationY <: AbstractDefinitePolarisation end
const PolY = PolarisationY


const BASE_POLARISATION_X = SLorentzVector(0,1,0,0)
const BASE_POLARISATION_Y = SLorentzVector(0,0,1,0)


@inline _default_polarisation_vector(::PolX) = BASE_POLARISATION_X
@inline _default_polarisation_vector(::PolY) = BASE_POLARISATION_Y

@inline _default_oscillator(::PolX, x) = cos(x)
@inline _default_oscillator(::PolY, x) = sin(x)  
