module QEDfields

using QEDbase
using QEDcore

using IntervalSets
using QuadGK

export AbstractBackgroundField, AbstractPulsedPlaneWaveField
export reference_momentum, domain, pulse_length, envelope, amplitude, generic_spectrum

export polarization_vector, oscillator

export CosSquarePulse

include("interfaces/background_field_interface.jl")
include("polarization.jl")
include("pulses/cos_square.jl")

end
