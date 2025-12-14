# TODO: implement in-place versions:
# - amplitude!
# - compute!
# - internal_integrals!
# - volkov_phase!
# - integrate!
#
module QEDfields

# result types
export InternalIntegralResult, InternalIntegrals, PhaseIntegralResult, PhaseIntegrals

# background fields
export AbstractBackgroundField

# plane-wave fields
export AbstractPlaneWaveField, polarization_type
export oscillator
export amplitude, reference_momentum, polarization, classical_nonlinearity_parameter
export a0_parameter, internal_integrals, volkov_phase, phase_integrals
export maximum_amplitude

# pulsed fields
export AbstractPulsedPlaneWaveField
export pulse_profile
export PulsedPlaneWaveField

# pulse profiles
export AbstractPulseProfile
export domain, compact_domain, pulse_length, envelope
export CosSquarePulse
export GaussianPulse

# integration methods
export integrate
export GaussKronrodQuadrature
export GaussLegendreQuadrature
export FilonClenshawCurtisQuadrature
export Analytical

using QuadGK
using FastGaussQuadrature
using IntervalSets
using LinearAlgebra
using SpecialFunctions


using QEDcore
using QEDbase

include("patch_QEDcore.jl")
include("results.jl")

include("integration_methods/interface.jl")
include("integration_methods/gauss_kronrod.jl")
include("integration_methods/gauss_legendre.jl")
include("integration_methods/filon_clenshaw_curtis.jl")
include("integration_methods/analytical.jl")

include("interface.jl")
include("generic/amplitude.jl")
include("generic/internal_integrals.jl")
include("generic/volkov_phase.jl")
include("generic/phase_integrals.jl")

include("pulse_profiles/interface.jl")
include("pulse_profiles/generic.jl")
include("pulse_profiles/cos_square/impl.jl")
include("pulse_profiles/cos_square/internal_integrals.jl")
include("pulse_profiles/gaussian_pulse/impl.jl")

include("pulsed_fields/interface.jl")
include("pulsed_fields/generic.jl")
include("pulsed_fields/impl.jl")

end
