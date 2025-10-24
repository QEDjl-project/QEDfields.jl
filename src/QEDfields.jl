# TODO: implement in-place versions:
# - amplitude!
# - compute!
# - internal_integals!
# - volkov_phase!
# - integrate!
#
module QEDfields

# background fields
export AbstractBackgroundField

# plane-wave fields
export AbstractPlaneWaveField
export amplitude, reference_momentum, polarization, classical_nonlinearity_parameter, a0_parameter
export maximum_amplitude

# pulsed fields
export AbstractPulsedPlaneWaveField
export pulse_profile
export PulsedPlaneWaveField

# pulse profiles
export AbstractPulseProfile
export domain, pulse_length, envelope
export CosSquarePulse
export GaussianPulse

# integration methods
export integrate
export GaussKronrodQuadrature
export GaussLegendreQuadrature
export Analytical

# internal integrals

using QuadGK
using FastGaussQuadrature
using IntervalSets
using LinearAlgebra

using QEDcore
using QEDbase

include("patch_QEDcore.jl")

include("integration_methods/interface.jl")
include("integration_methods/gauss_kronrod.jl")
include("integration_methods/gauss_legendre.jl")
include("integration_methods/analytical.jl")

include("interface.jl")
include("generic.jl")

include("pulse_profiles/interface.jl")
include("pulse_profiles/cos_square/impl.jl")
include("pulse_profiles/gaussian_pulse/impl.jl")

include("pulsed_fields/interface.jl")
include("pulsed_fields/generic.jl")
include("pulsed_fields/impl.jl")

end
