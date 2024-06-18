module QEDfields

import QEDbase
using QEDcore

using IntervalSets
using QuadGK

export dummy_QEDbase

# Write your package code here.
function dummy_QEDbase(x::AbstractVector{T}) where {T<:Real}
    length(x) == 4 ||
        error("The length of the input needs to be four. <$(length(x))> given.")
    @inbounds SFourMomentum(x...)
end

export AbstractBackgroundField, AbstractPulsedPlaneWaveField
export reference_momentum, domain, pulse_length, envelope, amplitude, generic_spectrum

export polarization_vector, oscillator

export CosSquarePulse

include("interfaces/background_field_interface.jl")
include("polarization.jl")
include("pulses/cos_square.jl")

end
