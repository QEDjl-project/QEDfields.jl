module QEDfields

using QEDbase
using QEDcore

using IntervalSets
using QuadGK

export AbstractBackgroundField, AbstractPulsedPlaneWaveField
export reference_momentum, domain, pulse_length, envelope, amplitude, generic_spectrum

export polarization_vector, oscillator

export CosSquarePulse, GaussianPulse

export phase_integral_0, phase_integral_1, phase_integral_2

include("interfaces/background_field_interface.jl")
include("polarization.jl")
include("pulses/cos_square.jl")
include("pulses/gaussian.jl")
include("phase_integrals/phase_integrals.jl")

end
